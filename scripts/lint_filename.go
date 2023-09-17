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
)

func lintFileName() {
	parentDir, err := os.Getwd()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	goRegex := regexp.MustCompile(`^[a-zA-Z][a-zA-Z0-9_]*\.go$`)

	err = filepath.Walk(parentDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if info.IsDir() {
			return nil
		}

		if filepath.Ext(path) != ".go" {
			return nil
		}

		filename := filepath.Base(path)

		if !goRegex.MatchString(filename) {
			return fmt.Errorf("%s is not a valid filename for Go code, only alpha, numbers and underscores are supported", filename)
		}

		return nil
	})
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
