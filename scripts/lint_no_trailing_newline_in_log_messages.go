package main

import (
	"fmt"
	"io/fs"
	"os"
	"regexp"
	"strings"
)

var exDirs []string

func main() {

	parentDir, err := os.Getwd()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	configFile := parentDir + "/.ci.conf"
	exDirs, err = parseBashStringArray("EXCLUDE_DIRECTORIES", configFile)
	if err != nil {
		fmt.Println(err)
		return
	}

	var filesToCheck []string
	err = fs.WalkDir(os.DirFS(parentDir+"/.."), ".", func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}

		if isExcluded(path) {
			return fs.SkipDir
		}
		if d.IsDir() || !strings.HasSuffix(d.Name(), ".go") {
			return nil
		}

		filesToCheck = append(filesToCheck, path)
		return nil
	})

	if err != nil {
		fmt.Println(err)
		return
	}

	logReg, err := regexp.Compile(`\.(Trace|Debug|Info|Warn|Error)f?\("[^"]*\\n"\)?`)
	if err != nil {
		fmt.Println(err)
		return
	}

	for _, filename := range filesToCheck {
		file, err := os.Open(parentDir + "/../" + filename)
		if err != nil {
			fmt.Println(err)
			return
		}
		defer file.Close()

		info, err := file.Stat()
		if err != nil {
			fmt.Println(err)
			return
		}

		buff := make([]byte, info.Size())

		_, err = file.Read(buff)
		if err != nil {
			fmt.Println(err)
			return
		}

		foundArr := logReg.FindAll(buff, -1)
		for _, match := range foundArr {
			if !strings.Contains(string(match), "nolint") {
				fmt.Println("Log format strings should have trailing new-line")
				os.Exit(1)
			}
		}
	}
}

func isExcluded(name string) bool {
	for _, dir := range exDirs {
		if name == dir {
			return true
		}
	}
	return false
}

func parseBashStringArray(variable, filename string) (arr []string, err error) {

	file, err := os.Open(filename)
	if err != nil {
		return []string{}, err
	}

	defer file.Close()

	info, err := file.Stat()
	if err != nil {
		return []string{}, err
	}

	buff := make([]byte, info.Size())

	_, err = file.Read(buff)
	if err != nil {
		return []string{}, err
	}

	fileString := string(buff)

	lines := strings.Split(fileString, "\n")
	bashLine := ""
	for line := range lines {
		if strings.Contains(lines[line], variable) {
			bashLine = lines[line]
			break
		}
	}

	if bashLine == "" {
		return []string{}, fmt.Errorf("%s not found error", variable)
	}

	bashLine = strings.TrimPrefix(bashLine, variable+"=")
	bashArray := strings.Fields(bashLine)
	bashArray[0] = bashArray[0][1:]
	bashArray[len(bashArray)-1] = strings.TrimRight(bashArray[len(bashArray)-1], ")")
	return bashArray, nil
}
