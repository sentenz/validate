# `/release`

- [`/release`](#release)
  - [Semantic-Release](#semantic-release)
    - [Requirements](#requirements)
    - [Install](#install)
    - [Troubleshooting](#troubleshooting)
  - [Usage](#usage)
  - [Configuration](#configuration)

## Semantic-Release

[semantic-release](https://github.com/semantic-release/semantic-release) automates the whole package release workflow including: determining the next version number, generating the release notes and publishing the package.

Related:

- [semantic-release - faq](https://semantic-release.gitbook.io/semantic-release/support/faq)
- [semantic-release - doc](https://github.com/semantic-release/semantic-release/blob/master/README.md#documentation)
- [semantic-release - plugins](https://semantic-release.gitbook.io/semantic-release/extending/plugins-list)
- [semantic-release - github-actions](https://github.com/semantic-release/semantic-release/blob/master/docs/recipes/github-actions.md)
- [semantic-release - azure](https://www.npmjs.com/package/semantic-release-ado?activeTab=readme)
- [semantic-commitlint](https://github.com/adriancarriger/semantic-commitlint)

### Requirements

In order to use **semantic-release** you need:

- To save your code in a [Git repository](https://git-scm.com)
- Use a Continuous Integration service that allows you to [securely set up credentials](https://github.com/semantic-release/semantic-release/blob/master/docs/usage/ci-configuration.md#authentication)
- Git CLI version [2.7.1 or higher](https://github.com/semantic-release/semantic-release/blob/master/docs/support/FAQ.md#why-does-semantic-release-require-git-version--271) installed in your Continuous Integration environment
- [Node.js](https://nodejs.org) version [10.19 or higher](https://github.com/semantic-release/semantic-release/blob/master/docs/support/node-version.md) installed in your Continuous Integration environment
- NPM 6.14.14 or higher

### Install

1. [Creating a package.json file](https://docs.npmjs.com/creating-a-package-json-file)

   ```bash
   # Creating a new package.json file
   npm init

   # Creating a default package.json file
   npm init --yes
   ```

2. [Install semantic-release in your project](https://github.com/semantic-release/semantic-release/blob/master/docs/usage/installation.md#installation)

   In order to use semantic-release you must follow these steps:

   ```bash
   # Local installation
   npm install --save-dev semantic-release
   npm install --save-dev semantic-release @semantic-release/{git,commit-analyzer,release-notes-generator,npm,changelog}

   # Global installation
   sudo npm install --save-dev -g semantic-release
   ```

   To use semantic release plugin for automatic builds on Azure DevOps pipelines run:

   ```bash
   npm install --save-dev semantic-release-ado
   ```

   Alternatively those steps can be done with the [semantic-release interactive CLI](https://github.com/semantic-release/cli#what-it-does):

   ```bash
   cd your-module
   npx semantic-release-cli setup
   ```

### [Troubleshooting](https://github.com/semantic-release/semantic-release/blob/master/docs/support/troubleshooting.md)

To verify if your package name is available you can use [npm-name-cli](https://github.com/sindresorhus/npm-name-cli):

```bash
npm install -g npm-name-cli
npm-name <package-name>
```

If the package name is not available, change it in your package.json or consider using an [npm scope](https://docs.npmjs.com/cli/v7/using-npm/scope).

Useful commands:

```bash
npm i --package-lock-only
sudo npm -g ci
```

## Usage

```bash
# Run semantic-release in ci
npx semantic-release

# Dry-Run semantic-release locally
NPM_TOKEN=<your_npm_token> GH_TOKEN=<your_github_token> npx semantic-release -d --no-ci
```

Examples of using semantic-release on the pipeline job:

- Github

  ```yml
  release:
    name: Release
    runs-on: ubuntu-latest
    steps:
      - name: Checkout project
        uses: actions/checkout@v2

      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: 12
          cache: npm

      - name: Install dependencies
        run: npm ci --ignore-scripts

      - name: Release project
        run: npx semantic-release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  ```

- Azure DevOps

  ```yml
  - job: release
   - task: NodeTool@0
      displayName: Setup Node.js
      inputs:
        versionSpec: '12.x'

    - task: Npm@1
      displayName: Setup NPM
      inputs:
        command: 'install'

    - task: CmdLine@2
      displayName: Install dependencies
      continueOnError: true
      inputs:
        script: npm ci --ignore-scripts

    - script: npx semantic-release
      displayName: Release project
      env:
        GIT_CREDENTIALS: $(System.AccessToken)
  ```

## Configuration

semantic-release [options](https://github.com/semantic-release/semantic-release/blob/master/docs/usage/configuration.md#configuration), mode and [plugins](https://github.com/semantic-release/semantic-release/blob/master/docs/usage/plugins.md) can be set via either:

- A `.releaserc` file, written in YAML or JSON, with optional extensions: .`yaml`/`.yml`/`.json`/`.js`
- A `release.config.js` file that exports an object
- A `release` key in the project's `package.json` file

Alternatively, some options can be set via CLI arguments.

The following three examples are the same.

- Via `.releaserc` file:

  ```json
  {
    "branches": ["main", "next"]
  }
  ```

- Via CLI argument:

  ```bash
  semantic-release --branches next
  ```

- Via `release` key in the project's `package.json` file:

  ```json
  {
    "release": {
      "branches": ["main", "next"]
    }
  }
  ```

Examples of version description of the `.releaserc.json` file with generic content:

```json
{
  "branches": ["main", "release/+([0-9])?(.{+([0-9]),x}).x", "develop/*"],
  "plugins": [
    [
      "@semantic-release/commit-analyzer",
      {
        "verifyRelease": ["semantic-commitlint"],
        "releaseRules": [
          {
            "type": "docs",
            "release": "patch"
          },
          {
            "type": "style",
            "release": "patch"
          },
          {
            "type": "refactor",
            "release": "patch"
          },
          {
            "type": "perf",
            "release": "minor"
          }
        ],
        "parserOpts": {
          "noteKeywords": ["BREAKING CHANGE", "BREAKING CHANGES"]
        }
      }
    ],
    "@semantic-release/release-notes-generator",
    [
      "@semantic-release/npm",
      {
        "npmPublish": false
      }
    ],
    "@semantic-release/changelog",
    "@semantic-release/git"
  ]
}
```

**Note**: Add the appropriate pipeline plugin to the `.releaserc.json` file.

- The plugin for **Github** can be configured in the semantic-release configuration file `.releaserc.json`:

  ```bash
  {
    "plugins": [
      "@semantic-release/github"
    ]
  }
  ```

- The plugin for **Azure DevOps** can be configured in the semantic-release configuration file `.releaserc.json`:

  ```bash
  {
    "plugins": [
      [
        "semantic-release-ado",
        {
          "varName": "version",
          "setOnlyOnRelease": true
        }
      ]
    ]
  }
  ```

  **Note**: In the example, the generated version number is stored in a variable called version.
