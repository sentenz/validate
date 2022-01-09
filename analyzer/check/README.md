# `/check`

- [1. Markdown Link Check](#1-markdown-link-check)
  - [1.1. Requirements](#11-requirements)
  - [1.2. Install](#12-install)
  - [1.3. Usage](#13-usage)
  - [1.4. Configuration](#14-configuration)
- [2. Markdown Spellcheck](#2-markdown-spellcheck)
  - [2.1. Requirements](#21-requirements)
  - [2.2. Install](#22-install)
  - [2.3. Usage](#23-usage)
  - [2.4. Configuration](#24-configuration)
- [3. Alex](#3-alex)
  - [3.1. Requirements](#31-requirements)
  - [3.2. Install](#32-install)
  - [3.3. Usage](#33-usage)
  - [3.4. Configuration](#34-configuration)
    - [3.4.1. Ignoring files](#341-ignoring-files)
    - [3.4.2. Resource files](#342-resource-files)
- [4. Codespell](#4-codespell)
  - [4.1. Requirements](#41-requirements)
  - [4.2. Install](#42-install)
  - [4.3. Usage](#43-usage)
  - [4.4. Configuration](#44-configuration)

## 1. Markdown Link Check

[markdown-link-check](https://github.com/tcort/markdown-link-check) extracts links from markdown texts and checks whether each link is alive or broken.

### 1.1. Requirements

- NPM 6.14.14 or higher.
- Node 12+

### 1.2. Install

To add the module to your project, run:

```bash
npm install --save-dev markdown-link-check
```

To install the command line tool globally, run:

```bash
npm install -g markdown-link-check
```

### 1.3. Usage

The [command line tool](https://github.com/tcort/markdown-link-check#command-line-tool) optionally takes 1 argument, the file name or http/https URL. If not supplied, the tool reads from standard input.

```bash
# Check links from a markdown file hosted on the web
markdown-link-check https://github.com/tcort/markdown-link-check/blob/master/README.md

# Check links from a local markdown file
markdown-link-check ./README.md

# Check links from a local markdown folder (recursive)
find . -name \*.md -exec markdown-link-check {} \;
```

### 1.4. Configuration

Command line options `-c` can also be specified in a config file.

Example:

```json
{
  "ignorePatterns": [
    {
      "pattern": "^http://example.net"
    }
  ],
  "replacementPatterns": [
    {
      "pattern": "^.attachments",
      "replacement": "file://some/conventional/folder/.attachments"
    },
    {
      "pattern": "^/",
      "replacement": "{{BASEURL}}/"
    }
  ],
  "httpHeaders": [
    {
      "urls": ["https://example.com"],
      "headers": {
        "Authorization": "Basic Zm9vOmJhcg==",
        "Foo": "Bar"
      }
    }
  ],
  "timeout": "20s",
  "retryOn429": true,
  "retryCount": 5,
  "fallbackRetryDelay": "30s",
  "aliveStatusCodes": [200, 206]
}
```

## 2. Markdown Spellcheck

[markdown-spellcheck](https://github.com/lukeapage/node-markdown-spellcheck) reads markdown files and spellchecks them, using [open source Hunspell dictionary files](https://github.com/lukeapage/node-markdown-spellcheck#dictionaries-being-used).

### 2.1. Requirements

- NPM 6.14.14 or higher.
- Node 12+

### 2.2. Install

```bash
npm i -g markdown-spellcheck
```

### 2.3. Usage

```bash
# Interactive mode
mdspell "**/*.md"

# Excluding patterns
mdspell '**/*.md' '!**/node_modules/**/*.md'

# CLI options
mdspell --en-us -n -a --report '**/*.md' '!**/node_modules/**/*.md'
```

Below is an example of how to respond to misspellings.

```shell
$ mdspell README.md
Spelling - README.md
I have a nise sentenz.
?
  Ignore
  Add to file ignores
  Add to dictionary - case insensitive
  Enter correct spelling
  noise
  anise
  nine
  nice
  nose
```

### 2.4. Configuration

All exclusions will be stored in a `.spelling` file in the directory from which you run the command.

Example:

```txt
API
Backend
BlackDuck
Bundesbeauftragter
Bundesnetzagentur
Changelog
Changelogs
```

## 3. Alex

[alex](https://github.com/get-alex/alex) catch insensitive, inconsiderate writing.

### 3.1. Requirements

- NPM 6.14.14 or higher.
- Node 12+

### 3.2. Install

```bash
npm install -g alex
```

### 3.3. Usage

The CLI searches for files with a markdown or text extension when given directories (alex will find readme.md and path/to/file.txt).

```bash
alex .
```

### 3.4. Configuration

#### 3.4.1. [Ignoring files](https://github.com/get-alex/alex#ignoring-files)

To prevent files from being found, create an `.alexignore` file:

```bash
# `node_modules` is ignored by default.
CODE_OF_CONDUCT.md
vendor/
```

#### 3.4.2. [Resource files](https://github.com/get-alex/alex#configuration)

You can control alex through `.alexrc.yml` configuration files:

```yml
allow:
  - German
  - german
  - european
```

## 4. Codespell

[codespell](https://github.com/codespell-project/codespell) fix common misspellings in text files. It's designed primarily for checking misspelled words in source code, but it can be used with other files as well. It does not check for word membership in a complete dictionary, but instead looks for a set of common misspellings. This also means it shouldn't generate false-positives when you use a niche term it doesn't know about.

### 4.1. Requirements

Python 3.7 or higher.

### 4.2. Install

```bash
pip install codespell
```

### 4.3. Usage

For more in depth info please check usage with `codespell -h`.

Some noteworthy flags:

```bash
codespell -w, --write-changes
```

The `-w` flag will actually implement the changes recommended by codespell. Not running with `-w` flag is the same as with doing a dry run. It is recommended to run this with the `-i` or `--interactive` flag.:

```bash
# ".git" dir is not skipped by default: codespell-project/codespell#783
# Skipping nested dirs needs "./": codespell-project/codespell#99
codespell \
    --check-filenames \
    --check-hidden \
    --quiet-level 6 \
    --skip="*.json,*.txt,*.log,.git,./node_modules,./vendor"
```

### 4.4. Configuration

Command line options can also be specified in a config file.

When running codespell, it will check in the current directory for a file named `setup.cfg` or `.codespellrc` (or a file specified via --config), containing an entry named `[codespell]`. Each command line argument can be specified in this file (without the preceding dashes), for example:

```txt
[codespell]
skip = *.json,*.txt,*.log,.git,.spelling,*/node_modules,*/vendor
quiet-level = 3
check-filenames =
check-hidden =
```
