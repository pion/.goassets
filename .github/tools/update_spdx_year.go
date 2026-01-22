// SPDX-FileCopyrightText: 2026 The Pion community <https://pion.ly>
// SPDX-License-Identifier: MIT

package main

import (
	"bytes"
	"fmt"
	"io"
	"io/fs"
	"os"
	"path/filepath"
	"regexp"
	"time"
)

const headerSize = 1024

var (
	yearRE = regexp.MustCompile(`\d{4}(?:-\d{4})?( The Pion community <https://pion\.ly>)`)

	skipDirs = map[string]struct{}{
		".git":         {},
		"vendor":       {},
		"third_party":  {},
		"node_modules": {},
	}
)

func main() {
	currentYear := time.Now().Year()
	repl := fmt.Appendf(nil, "%d${1}", currentYear)

	var updatedFiles int

	err := filepath.WalkDir(".", func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}

		if d.IsDir() {
			if _, skip := skipDirs[d.Name()]; skip {
				return filepath.SkipDir
			}

			return nil
		}

		f, err := os.Open(path)
		if err != nil {
			return err
		}
		defer f.Close()

		header := make([]byte, headerSize)
		n, err := f.Read(header)
		if err != nil && err != io.EOF {
			return err
		}
		header = header[:n]

		if !yearRE.Match(header) {
			return nil
		}

		rest, err := io.ReadAll(f)
		if err != nil {
			return err
		}
		data := append(header, rest...)

		rewritten := yearRE.ReplaceAll(data, repl)

		if bytes.Equal(data, rewritten) {
			return nil
		}

		info, err := d.Info()
		if err != nil {
			return err
		}

		if err := os.WriteFile(path, rewritten, info.Mode()); err != nil {
			return err
		}

		updatedFiles++

		return nil
	})

	if err != nil {
		fmt.Fprintf(os.Stderr, "update failed: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("Updated %d file(s)\n", updatedFiles)
}
