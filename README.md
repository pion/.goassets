# .goassets
Asset files automatically deployed to Go package repositories

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

### License
MIT License - see [LICENSE](LICENSE) for full text
