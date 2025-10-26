package main

import (
	"fmt"
	"iter"
	"log"
	"os"
	"os/exec"
	"regexp"
	"strings"
)

func validateSubject(subj string) (bool, string) {
	if len(subj) > 50 {
		matched, err := regexp.Match("^Update module [0-9a-zA-Z./]+ to v[0-9]+\\.[0-9]+\\.[0-9]+( \\[.*\\])?$", []byte(subj))
		if err != nil {
			log.Fatal(err)
		}
		if matched {
			fmt.Println("Ignored subject line length error for module update commit")
		} else {
			return false, "Limit the subject line to 50 characters"
		}
	}
	not_capitalized, _ := regexp.Match("^[A-Z]", []byte(subj))
	if not_capitalized {
		return false, "Capitalize the subject line"
	}
	ends_with_period, _ := regexp.Match("\\.$", []byte(subj))
	if ends_with_period {
		return false, "Do not end the subject line with a period"
	}
	return true, ""
}

func printError(err_msg string, commit_msg string) {
	_, isCi := os.LookupEnv("CI")
	if isCi {
		fmt.Printf("::error title=Commit message check failed::%s\n", err_msg)
		fmt.Printf("::group::Commit message\n%s\n::endgroup::\n", commit_msg)
	} else {
		fmt.Printf("%s\n", commit_msg)
		fmt.Println("-------------------------------------------------")
	}
	fmt.Printf(`The preceding commit message is invalid
it failed '%s' of the following checks

* Separate subject from body with a blank line
* Limit the subject line to 50 characters
* Capitalize the subject line
* Do not end the subject line with a period
* Wrap the body at 72 characters
`, err_msg)
}

func lintCommitMessage(msg string) bool {
	lines := strings.Lines(msg)
	next, _ := iter.Pull(lines)
	subj, hasSubj := next()
	if !hasSubj {
		return false
	}
	subj_ok, err_msg := validateSubject(strings.TrimRight(subj, "\r\n"))
	if !subj_ok {
		printError(err_msg, msg)
		return false
	}
	subj_sep, hasSep := next()
	if !hasSep {
		return true
	}
	if len(strings.TrimRight(subj_sep, "\r\n")) != 0 {
		printError("Separate subject from body with a blank line", msg)
		return false
	}
	for l := range lines {
		if len(strings.TrimRight(l, "\r\n")) > 72 {
			printError("Wrap the body at 72 characters", msg)
			return false
		}
	}

	return true
}

func main() {
	if len(os.Args) > 1 {
		file, err := os.ReadFile(os.Args[1])
		if err != nil {
			log.Fatal(err)
		}
		if !lintCommitMessage(string(file)) {
			os.Exit(1)
		}
		return
	}

	base_ref, has_base_ref := os.LookupEnv("GITHUB_BASE_REF")
	if !has_base_ref {
		base_ref = "master"
	}
	git_proc := exec.Command("git", "rev-list", "--no-merges", fmt.Sprintf("origin/%s..", base_ref))
	out, err := git_proc.Output()
	if err != nil {
		log.Fatal(err)
	}
	for v := range strings.Lines(string(out)) {
		git_proc := exec.Command("git", "log", "--format=%B", "-n", "1", strings.TrimSpace(v))
		out, err := git_proc.Output()
		if err != nil {
			log.Fatal(err)
		}
		if !lintCommitMessage(string(out)) {
			os.Exit(1)
		}
	}
}
