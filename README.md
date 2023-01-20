# .goassets

Asset files automatically deployed to Go package repositories

[Search ongoing sync pull-requests.](https://github.com/search?q=org%3Apion+type%3Apr+author%3Apionbot+is%3Aopen&type=Issues)

### Usage

This repository has master data of the asset files like the lint scripts, coverage report config, renovate config.
Please make a pull-request on this repository to update these files, instead of editing them in each repository.

After merging changes to the master branch, a pull-request to sync the changes to https://github.com/pion/ci-sandbox will be automatically opened.
Feel free to commit sample data to ci-sandbox repository to test the changes.

When it is ready to sync to the all repositories, add a version tag to this repository.
GitHub Action will open pull-requests on the target repositories to sync the changes.

### Shell script format

- Formatter: https://github.com/mvdan/sh#shfmt
- Style guide: https://google.github.io/styleguide/shell.xml

```shell
shfmt -i 2 -ci -bn -l -w .
```

### Contributing

Check out the [contributing wiki](https://github.com/pion/webrtc/wiki/Contributing) to join the group of amazing people making this project possible in the [AUTHORS.txt](AUTHORS.txt) file

### License

MIT License - see [LICENSE](LICENSE) for full text
