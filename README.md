# Cloud-On-Mobile-iOS
Host cloud on your mobile - iOS app

# Setup

Section contains information how to run a project.

## [SwiftFormat](https://github.com/nicklockwood/SwiftFormat)

SwiftFormat has been configured for this project to format Swift code according to best practices.
SwiftFormat is added using git hooks, it will format code automatically before committing the code.

It requires running two commands to work properly:

1. make sure that hook has executable permissions:
`chmod +x .githooks/pre-commit` 

2. Setup git to use hooks properly:
`git config core.hooksPath .githooks`

You can see all aplied rules inside `.swiftformat` file.

## [SwiftGen](https://github.com/SwiftGen/SwiftGen)

SwiftGen has been configured for this project to generate enums for translations or assets.

It has been added as build phase and it will run with every build.

It requires to install it using Homebrew commands:
```bash
$ brew update
$ brew install swiftgen
```
