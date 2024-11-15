/*
SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
SPDX-License-Identifier: MIT
*/
package main

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

func main() {
	parentDir, err := os.Getwd()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	logReg, err := regexp.Compile(`\.(Trace|Debug|Info|Warn|Error)f?\("[^"]*\\n"\)?`)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	err = filepath.Walk(parentDir, func(path string, info os.FileInfo, err error) error {
		if err != nil || info.IsDir() || filepath.Ext(path) != ".go" {
			return err
		}

		fileContents, err := os.ReadFile(path)
		if err != nil {
			return err
		}

		for _, match := range logReg.FindAll(fileContents, -1) {
			if !strings.Contains(string(match), "nolint") {
				return fmt.Errorf("Log format strings should not have trailing new-line: %s", match)
			}
		}

		return nil
	})
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
