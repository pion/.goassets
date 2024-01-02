<h1 align="center">
  <br>
  Pion Go Assets
  <br>
</h1>
<h4 align="center">CI and other common configuration files</h4>
<p align="center">
  <a href="https://pion.ly"><img src="https://img.shields.io/badge/pion-goassets-gray.svg?longCache=true&colorB=brightgreen" alt="Pion Go Assets"></a>
  <a href="https://pion.ly/slack"><img src="https://img.shields.io/badge/join-us%20on%20slack-gray.svg?longCache=true&logo=slack&colorB=brightgreen" alt="Slack Widget"></a>
  <br>
  <img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/pion/.goassets/asset-sync.yaml">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
</p>
<br>

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

### Roadmap
The repository is used as a part of our WebRTC implementation. Please refer to that [roadmap](https://github.com/pion/webrtc/issues/9) to track our major milestones.

### Community
Pion has an active community on the [Slack](https://pion.ly/slack).

Follow the [Pion Twitter](https://twitter.com/_pion) for project updates and important WebRTC news.

We are always looking to support **your projects**. Please reach out if you have something to build!
If you need commercial support or don't want to use public methods you can contact us at [team@pion.ly](mailto:team@pion.ly)

### Contributing
Check out the [contributing wiki](https://github.com/pion/webrtc/wiki/Contributing) to join the group of amazing people making this project possible

### License
MIT License - see [LICENSE](LICENSE) for full text
