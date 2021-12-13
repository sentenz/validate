# `/analyzer`

Scripts to perform various install, analysis, test, build or release operations.

- [`/analyzer`](#analyzer)
  - [Git](#git)
    - [Hooks](#hooks)
    - [Requirements](#requirements)
    - [Install](#install)
    - [Usage](#usage)
  - [Husky](#husky)
    - [Requirements](#requirements-1)
    - [Install](#install-1)
    - [Uninstall](#uninstall)
    - [Configuration](#configuration)
    - [Troubelshoot](#troubelshoot)
  - [Node.js](#nodejs)
    - [Requirements](#requirements-2)
    - [Install](#install-2)
    - [Usage](#usage-1)
    - [Configuration](#configuration-1)
  - [Directories](#directories)
    - [`/env`](#env)
    - [`/lint`](#lint)
    - [`/check`](#check)
    - [`/format`](#format)
    - [`/legal`](#legal)
  - [`/version`](#version)

## Git

[Git](https://git-scm.com/)

### Hooks

[githooks](https://git-scm.com/docs/githooks)

### Requirements

`apt` package management system for installing, upgrading, configuring, and removing software.

### Install

```bash
sudo apt install -y git
```

### Usage

```bash
git init
```

## Husky

Husky improves your commits and more with modern native Git hooks.

### Requirements

- NPM 6.14.14 or higher.
- Node 12+

### Install

Install [husky](https://www.npmjs.com/package/husky?ref=hackernoon.com) with npm (Node package manager).

1. Install `husky`

   ```bash
   sudo npm i --silent -g husky@latest
   ```

2. Enable Git hooks

   ```bash
   npx husky install
   ```

3. Create a hook

   To add a command to a hook or create a new one, use `husky add <file> [cmd]` (don't forget to run `husky install` before).

   - pre-commit

     [pre-commit](https://www.npmjs.com/package/pre-commit) is a pre-commit hook installer for `git`. It will ensure that your `npm test` passes before you can commit your changes.

     Install `pre-commit`:

     ```bash
     sudo npm i --silent -g pre-commit@latest
     ```

     Add hook:

     ```bash
     npx husky add .husky/pre-commit "npm test"
     ```

   - commit-msg

     [commit-msg](https://www.npmjs.com/package/commit-msg) is a customizable git commit message parser and validator.

     Install `commit-msg`:

     ```bash
     sudo npm i --silent -g commit-msg@latest
     ```

     Add hook:

     ```bash
     npx husky add .husky/commit-msg "npx --no-install commitlint --edit"
     ```

### Uninstall

```bash
sudo npm uninstall -g husky
git config --unset core.hooksPath
```

### Configuration

- [Bypass hooks](https://typicode.github.io/husky/#/?id=bypass-hooks)

  You can bypass `pre-commit` and `commit-msg` hooks using Git `-n/--no-verify` option:

  ```bash
  git commit -m "yolo!" --no-verify
  ```

- [Disable husky in CI/Docker](https://typicode.github.io/husky/#/?id=disable-husky-in-cidocker)

  There's no right or wrong way to disable husky in CI/Docker context and is highly dependent on your use-case.

  With npm - If you want to prevent husky from installing completely:

  ```bash
  npm ci --omit=dev --ignore-scripts
  ```

### Troubelshoot

Sporadically there are problems with newer npm versions. Especially when combining sudo with npm commands the following error (or variants of it) occurs:

```bash
Error: EACCES: permission denied, scandir '/root/.npm/_logs'
```

Therefore, follow these rules for manual installations:

1. Whenever possible, do not use `npm` commands with `sudo`.

2. If it is absolutely necessary, specify the `-H` option. `--unsafe-perm` also avoids problems with installation scripts.

   ```bash
   sudo -H npm <commands> --unsafe-perm
   ```

3. If you are logged in as root (e.g. because there is no non-root user), it is recommended to specify the `--unsafe-perm` option during the installation.

   ```bash
   npm install <package> --unsafe-perm
   ```

## Node.js

### Requirements

`apt` package management system for installing, upgrading, configuring, and removing software.

### Install

Installing Node.js via package manager. Debian and Ubuntu based Linux distributions are available from [Node.js binary distributions](https://github.com/nodesource/distributions/blob/master/README.md).

[Node.js v12.x](https://github.com/nodesource/distributions/blob/master/README.md#installation-instructions):

```bash
# Using Ubuntu
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install -y nodejs
```

### Usage

Install `npm`, the Node.js package manager.

```bash
sudo apt install -y npm
```

### Configuration

[Configuring npm](https://docs.npmjs.com/cli/v6/configuring-npm).

Creating a `package.json` file:

```bash
npm init
```

A package.json file:

- lists the packages your project depends on
- specifies versions of a package that your project can use using semantic versioning rules
- makes your build reproducible, and therefore easier to share with other developers

[Installs a package](https://docs.npmjs.com/cli/v6/commands/npm-install), and any packages that it depends on.

```bash
npm install
```

## Directories

### `/env`

Scripts to `setup` the environment, run tests and build the application via CLI.

- [ ] test
- [ ] build
- [x] install

### `/lint`

Linting scripts to `validate` the code base via CLI.

- [ ] [mega-lint](https://github.com/nvuillam/mega-linter)
- [x] [remark-lint](https://github.com/remarkjs/remark-lint)
- [x] golangci-lint
- [x] clang-tidy
- [x] cpplint
- [x] shellcheck
- [x] markdownlint
- [x] commitlint
- [x] jsonlint

### `/check`

Checking scripts to `validate` the code base via CLI.

- [ ] [ineffassign](https://github.com/gordonklaus/ineffassign)
- [ ] [errcheck](https://github.com/kisielk/errcheck)
- [ ] [misspell](https://github.com/client9/misspell)
- [ ] [gocyclo](https://github.com/fzipp/gocyclo)
- [ ] clang-analyzer (scan-build)
- [x] valgrind
- [x] staticcheck
- [x] cppcheck
- [x] markdown-link-check
- [x] markdown-spell-check
- [x] alex
- [x] codespell

### `/format`

Formatting scripts to `validate` the code base via CLI.

- [x] gofmt
- [x] clang-format
- [x] shfmt
- [x] [markdown-table-formatter](https://github.com/nvuillam/markdown-table-formatter)

### `/legal`

Legalization scripts to `validate` the code base via CLI.

- [ ] [licensing](https://code.tools/man/1/licensing)
- [ ] [golicense](https://github.com/mitchellh/golicense)
- [x] licensecheck

## `/version`

Versioning scripts for the CI/CD pipeline. Including an automated `release` workflow with determining the next version number, creating release notes and publishing the package.

- [x] semantic-release
