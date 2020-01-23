# .goassets
Asset files automatically deployed to Go package repositories

[Search ongoing sync pull-requests.](https://github.com/search?q=org%3Apion+type%3Apr+author%3Apionbot+is%3Aopen&type=Issues)

### Usage
This repository has master data of the asset files like the lint scripts, coverage report config, renovate config.
Please make a pull-request on this repository to update these files, instead of editing them in each repository.

After updating the files, add a version tag to this repository.
GitHub Action will open pull-requests on the target repositories to sync the changes.

### Contributing
Check out the **[contributing wiki](https://github.com/pion/webrtc/wiki/Contributing)** to join the group of amazing people making this project possible:

* [Sean DuBois](https://github.com/Sean-Der) - *Original Author of the lint scripts*
* [Max Hawkins](https://github.com/maxhawkins) - *Git hooks*
* [Atsushi Watanabe](https://github.com/at-wat) - *Sync files among repositories*
* [Daniele Sluijters](https://github.com/daenney) - *Misc fixes*
* [Luke S](https://github.com/encounter)

### License
MIT License - see [LICENSE](LICENSE) for full text
