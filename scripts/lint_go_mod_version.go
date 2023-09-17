/*
SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
SPDX-License-Identifier: MIT
*/
package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"regexp"
)

func lintGoModVersion() {
	// Get the path of the current script
	scriptPath, err := filepath.Abs(os.Args[0])
	if err != nil {
		log.Fatal(err)
	}
	scriptDir := filepath.Dir(scriptPath)

	// Read the .ci.conf file if it exists
	ciConfPath := filepath.Join(scriptDir, ".ci.conf")
	if _, err := os.Stat(ciConfPath); err == nil {
		if err := readCiConf(ciConfPath); err != nil {
			log.Fatal(err)
		}
	}

	// Read the go.mod file and extract the Go version information
	goModPath := filepath.Join(scriptDir, "go.mod")
	goModFile, err := os.Open(goModPath)
	if err != nil {
		log.Fatal(err)
	}
	defer goModFile.Close()

	scanner := bufio.NewScanner(goModFile)
	re := regexp.MustCompile("^go\\s+([\\d.]+)$")
	var goModVersion string
	for scanner.Scan() {
		line := scanner.Text()
		if matches := re.FindStringSubmatch(line); matches != nil {
			goModVersion = matches[1]
			break
		}
	}
	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	expectedVersion := "1.19"
	if goModVersion != expectedVersion {
		if os.Getenv("CI") != "" {
			goModVersionLine := getGoModVersionLine(goModPath, goModVersion)
			fmt.Printf("::error title=Invalid Go version,file=%s,line=%d,::Found %s. Expected %s\n", goModPath, goModVersionLine, goModVersion, expectedVersion)
		} else {
			fmt.Printf("Invalid Go version in %s:\n", goModPath)
			fmt.Printf("  Found    %s\n", goModVersion)
			fmt.Printf("  Expected %s\n", expectedVersion)
		}
		os.Exit(1)
	}
}

func readCiConf(ciConfPath string) error {
	ciConfFile, err := os.Open(ciConfPath)
	if err != nil {
		return err
	}
	defer ciConfFile.Close()

	// read and process the .ci.conf file
	// ...

	return nil
}

func getGoModVersionLine(goModPath, goModVersion string) int {
	goModFile, err := os.Open(goModPath)
	if err != nil {
		log.Fatal(err)
	}
	defer goModFile.Close()

	scanner := bufio.NewScanner(goModFile)
	re := regexp.MustCompile(fmt.Sprintf("^go\\s+%s$", regexp.QuoteMeta(goModVersion)))
	for lineNumber := 1; scanner.Scan(); lineNumber++ {
		if re.MatchString(scanner.Text()) {
			return lineNumber
		}
	}
	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	return -1 // not found
}
