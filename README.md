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

### Contributing

Check out the **[contributing wiki](https://github.com/pion/webrtc/wiki/Contributing)** to join the group of amazing people making this project possible:

- [Sean DuBois](https://github.com/Sean-Der) - _Original Author of the lint scripts_
- [Max Hawkins](https://github.com/maxhawkins) - _Git hooks_
- [Atsushi Watanabe](https://github.com/at-wat) - _Sync files among repositories_
- [Daniele Sluijters](https://github.com/daenney) - _Misc fixes_
- [Luke S](https://github.com/encounter)
- [Aurken Bilbao](https://github.com/aurkenb) - _Misc fixes_
- [Tarrence van As](https://github.com/tarrencev)
- [Michiel De Backker](https://github.com/backkem) - _Add pion/udp_
- [ZHENK](https://github.com/scorpionknifes)
- [Adam Kiss](https://github.com/masterada) - _Added .gitignore_
- [David Zhao](https://github.com/davidzhao) - _Added print lint_

### License

MIT License - see [LICENSE](LICENSE) for full text
