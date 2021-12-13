# `/check`

- [`/check`](#check)
  - [Markdown Link Check](#markdown-link-check)
    - [Requirements](#requirements)
    - [Install](#install)
    - [Usage](#usage)
    - [Configuration](#configuration)
  - [Markdown Spellcheck](#markdown-spellcheck)
    - [Requirements](#requirements-1)
    - [Install](#install-1)
    - [Usage](#usage-1)
    - [Configuration](#configuration-1)
  - [Alex](#alex)
    - [Requirements](#requirements-2)
    - [Install](#install-2)
    - [Usage](#usage-2)
    - [Configuration](#configuration-2)
      - [Ignoring files](#ignoring-files)
      - [Resource files](#resource-files)
  - [Codespell](#codespell)
    - [Requirements](#requirements-3)
    - [Install](#install-3)
    - [Usage](#usage-3)
    - [Configuration](#configuration-3)

## Markdown Link Check

[markdown-link-check](https://github.com/tcort/markdown-link-check) extracts links from markdown texts and checks whether each link is alive or broken.

### Requirements

- NPM 6.14.14 or higher.
- Node 12+

### Install

To add the module to your project, run:

```bash
npm install --save-dev markdown-link-check
```

To install the command line tool globally, run:

```bash
npm install -g markdown-link-check
```

### Usage

The [command line tool](https://github.com/tcort/markdown-link-check#command-line-tool) optionally takes 1 argument, the file name or http/https URL. If not supplied, the tool reads from standard input.

```bash
# Check links from a markdown file hosted on the web
markdown-link-check https://github.com/tcort/markdown-link-check/blob/master/README.md

# Check links from a local markdown file
markdown-link-check ./README.md

# Check links from a local markdown folder (recursive)
find . -name \*.md -exec markdown-link-check {} \;
```

### Configuration

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

## Markdown Spellcheck

[markdown-spellcheck](https://github.com/lukeapage/node-markdown-spellcheck) reads markdown files and spellchecks them, using [open source Hunspell dictionary files](https://github.com/lukeapage/node-markdown-spellcheck#dictionaries-being-used).

### Requirements

- NPM 6.14.14 or higher.
- Node 12+

### Install

```bash
npm i -g markdown-spellcheck
```

### Usage

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

### Configuration

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

## Alex

[alex](https://github.com/get-alex/alex) catch insensitive, inconsiderate writing.

### Requirements

- NPM 6.14.14 or higher.
- Node 12+

### Install

```bash
npm install -g alex
```

### Usage

The CLI searches for files with a markdown or text extension when given directories (alex will find readme.md and path/to/file.txt).

```bash
alex .
```

### Configuration

#### [Ignoring files](https://github.com/get-alex/alex#ignoring-files)

To prevent files from being found, create an `.alexignore` file:

```bash
# `node_modules` is ignored by default.
CODE_OF_CONDUCT.md
vendor/
```

#### [Resource files](https://github.com/get-alex/alex#configuration)

You can control alex through `.alexrc.yml` configuration files:

```yml
allow:
  - German
  - german
  - european
```

## Codespell

[codespell](https://github.com/codespell-project/codespell) fix common misspellings in text files. It's designed primarily for checking misspelled words in source code, but it can be used with other files as well. It does not check for word membership in a complete dictionary, but instead looks for a set of common misspellings. This also means it shouldn't generate false-positives when you use a niche term it doesn't know about.

### Requirements

Python 3.7 or higher.

### Install

```bash
pip install codespell
```

### Usage

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

### Configuration

Command line options can also be specified in a config file.

When running codespell, it will check in the current directory for a file named `setup.cfg` or `.codespellrc` (or a file specified via --config), containing an entry named `[codespell]`. Each command line argument can be specified in this file (without the preceding dashes), for example:

```txt
[codespell]
skip = *.json,*.txt,*.log,.git,.spelling,*/node_modules,*/vendor
quiet-level = 3
check-filenames =
check-hidden =
```
