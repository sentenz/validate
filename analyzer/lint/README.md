# `/linter`

- [1. Clang-Tidy](#1-clang-tidy)
  - [1.1. Requirements](#11-requirements)
  - [1.2. Install](#12-install)
  - [1.3. Usage](#13-usage)
- [2. Cpplint](#2-cpplint)
  - [2.1. Requirements](#21-requirements)
  - [2.2. Install](#22-install)
  - [2.3. Usage](#23-usage)
  - [2.4. Configuration](#24-configuration)
- [3. Cppcheck](#3-cppcheck)
  - [3.1. Requirements](#31-requirements)
  - [3.2. Install](#32-install)
  - [3.3. Usage](#33-usage)
  - [3.4. Configuration](#34-configuration)
- [4. Golangci-lint](#4-golangci-lint)
  - [4.1. Requirements](#41-requirements)
  - [4.2. Install](#42-install)
  - [4.3. Usage](#43-usage)
  - [4.4. Configuration](#44-configuration)
  - [4.5. Troubleshoot](#45-troubleshoot)
- [5. Shellcheck](#5-shellcheck)
  - [5.1. Requirements](#51-requirements)
  - [5.2. Install](#52-install)
  - [5.3. Usage](#53-usage)
  - [5.4. Configuration](#54-configuration)
- [6. Commitlint](#6-commitlint)
  - [6.1. Requirements](#61-requirements)
  - [6.2. Install](#62-install)
  - [6.3. Uninstall](#63-uninstall)
  - [6.4. Usage](#64-usage)
  - [6.5. Configuration](#65-configuration)
- [7. Makrdownlint](#7-makrdownlint)
  - [7.1. Requirements](#71-requirements)
  - [7.2. Install](#72-install)
  - [7.3. Uninstall](#73-uninstall)
  - [7.4. Usage](#74-usage)
  - [7.5. Configuration](#75-configuration)
- [8. Yamllint](#8-yamllint)
  - [8.1. Requirements](#81-requirements)
  - [8.2. Install](#82-install)
  - [8.3. Usage](#83-usage)
  - [8.4. Configuration](#84-configuration)
- [9. Jsonlint](#9-jsonlint)
  - [9.1. Requirements](#91-requirements)
  - [9.2. Install](#92-install)
  - [9.3. Uninstall](#93-uninstall)
  - [9.4. Usage](#94-usage)
- [10. Remark](#10-remark)
  - [10.1. Requirements](#101-requirements)
  - [10.2. Install](#102-install)
  - [10.3. Uninstall](#103-uninstall)
  - [10.4. Usage](#104-usage)
  - [10.5. Configuration](#105-configuration)
- [11. Dockerfilelint](#11-dockerfilelint)
  - [11.1. Requirements](#111-requirements)
  - [11.2. Install](#112-install)
  - [11.3. Usage](#113-usage)
  - [11.4. Configuration](#114-configuration)

## 1. Clang-Tidy

[clang-tidy](https://clang.llvm.org/extra/clang-tidy/) is a clang-based C++ **linter** tool. Its purpose is to provide an extensible framework for diagnosing and fixing typical programming errors, like style violations, interface misuse, or bugs that can be deduced via static analysis. clang-tidy is modular and provides a convenient interface for writing new checks.

### 1.1. Requirements

`apt` package management system for installing, upgrading, configuring, and removing software.

### 1.2. Install

```bash
sudo apt install -y clang-tidy
```

### 1.3. Usage

clang-tidy is a LibTooling-based tool, and it’s easier to work with if you set up a compile command database for your project (for an example of how to do this see [How To Setup Tooling For LLVM](https://clang.llvm.org/docs/HowToSetupToolingForLLVM.html)). You can also specify compilation options on the command line after `--`:

```bash
clang-tidy test.cpp -- -Imy_project/include -DMY_DEFINES ...
```

clang-tidy has its own checks and can also run Clang static analyzer checks. Each check has a name and the checks to run can be chosen using the `-checks=` option, which specifies a comma-separated list of positive and negative (prefixed with -) globs. Positive globs add subsets of checks, negative globs remove them. For example,

```bash
clang-tidy test.cpp -checks=-*,clang-analyzer-*,-clang-analyzer-cplusplus*
```

## 2. Cpplint

[cpplint](https://github.com/cpplint/cpplint) is a command-line tool to check C/C++ files for style issues following [Google's C++ style guide](https://google.github.io/styleguide/cppguide.html).

### 2.1. Requirements

Python 3.7 or higher.

### 2.2. Install

To install cpplint from PyPI, run:

```bash
sudo pip install cpplint
```

### 2.3. Usage

Run it with:

```bash
cpplint --exclude=node_modules --recursive .
```

For full usage instructions, run:

```bash
cpplint --help
```

### 2.4. Configuration

cpplint supports per-directory configurations specified in [CPPLINT.cfg](https://nvuillam.github.io/mega-linter/descriptors/c_cpplint/) files. CPPLINT.cfg file can contain a number of key=value pairs. Currently the following options are supported:

```conf
set noparent
filter=+filter1,-filter2,...
exclude_files=regex
linelength=80
root=subdir
headers=x,y,...
```

Example:

```conf
set noparent
linelength=100
filter=-build/c++11
filter=-readability/casting
filter=-runtime/arrays
```

## 3. Cppcheck

[cppcheck](https://github.com/danmar/cppcheck) is designed for both C and C++.

### 3.1. Requirements

`apt` package management system for installing, upgrading, configuring, and removing software.

### 3.2. Install

```bash
sudo apt install -y cppcheck
```

### 3.3. Usage

```bash
cppcheck .

cppcheck --enable=warning --suppressions-list=cppcheck-suppressions.txt --template='[{file}:{line}]:({severity}),{id},{message}' .
```

### 3.4. Configuration

Configure `cppcheck-suppressions.txt` in the project.

Example:

```txt
missingIncludeSystem
unusedFunction
*:../../build
*:../../node_modules
```

## 4. Golangci-lint

[golangci-lint](https://github.com/golangci/golangci-lint) is a fast Go linters runner. It runs linters in parallel, uses caching, supports yaml config, has integrations with all major IDE and has dozens of linters included.

See a list of supported [linters](https://golangci-lint.run/usage/linters/).

### 4.1. Requirements

Go 1.15 or higher.

### 4.2. Install

Most [installations of golangci-lint](https://golangci-lint.run/usage/install/#local-installation) are performed for CI.

```bash
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go mod vendor
export PATH=${PATH}:${HOME}/go/bin
```

### 4.3. Usage

```bash
golangci-lint run ./...
```

### 4.4. Configuration

- [Editor Integration](https://golangci-lint.run/usage/integrations/)

  ```json
  "go.lintTool":"golangci-lint",
  "go.lintFlags": [
    "--fast"
  ]
  ```

- [Configuration File](https://golangci-lint.run/usage/configuration/)

  The configuration files are named [.golangci.yml](https://github.com/golangci/golangci-lint/blob/master/.golangci.example.yml) and are automatically recognized.

  Enabled by your configuration linters:

  - asciicheck: Linter to check that your code does not contain non-ASCII identifiers `[fast: true, auto-fix: false]`
  - bidichk: Checks for dangerous unicode character sequences `[fast: true, auto-fix: false]`
  - bodyclose: checks whether HTTP response body is closed successfully `[fast: false, auto-fix: false]`
  - contextcheck: check the function whether use a non-inherited context `[fast: false, auto-fix: false]`
  - cyclop: checks function and package cyclomatic complexity `[fast: false, auto-fix: false]`
  - deadcode: Finds unused code `[fast: false, auto-fix: false]`
  - depguard: Go linter that checks if package imports are in a list of acceptable packages `[fast: false, auto-fix: false]`
  - dogsled: Checks assignments with too many blank identifiers, e.g. `x, _,_, \_, := f()` `[fast: true, auto-fix: false]`
  - dupl: Tool for code clone detection `[fast: true, auto-fix: false]`
  - durationcheck: check for two durations multiplied together `[fast: false, auto-fix: false]`
  - errcheck: Errcheck is a program for checking for unchecked errors in go programs. These unchecked errors can be critical bugs in some cases `[fast: false, auto-fix: false]`
  - errname: Checks that sentinel errors are prefixed with the `Err` and error types are suffixed with the `Error`. `[fast: false, auto-fix: false]`
  - errorlint: errorlint is a linter for that can be used to find code that will cause problems with the error wrapping scheme introduced in Go 1.13. `[fast: false, auto-fix: false]`
  - exhaustive: check exhaustiveness of enum switch statements `[fast: false, auto-fix: false]`
  - exhaustivestruct: Checks if all struct's fields are initialized `[fast: false, auto-fix: false]`
  - exportloopref: checks for pointers to enclosing loop variables `[fast: false, auto-fix: false]`
  - forbidigo: Forbids identifiers `[fast: true, auto-fix: false]`
  - forcetypeassert: finds forced type assertions `[fast: true, auto-fix: false]`
  - funlen: Tool for detection of long functions `[fast: true, auto-fix: false]`
  - gci: Gci control golang package import order and make it always deterministic. `[fast: true, auto-fix: true]`
  - gochecknoinits: Checks that no init functions are present in Go code `[fast: true, auto-fix: false]`
  - gocognit: Computes and checks the cognitive complexity of functions `[fast: true, auto-fix: false]`
  - goconst: Finds repeated strings that could be replaced by a constant `[fast: true, auto-fix: false]`
  - gocritic: Provides diagnostics that check for bugs, performance and style issues. `[fast: false, auto-fix: false]`
  - gocyclo: Computes and checks the cyclomatic complexity of functions `[fast: true, auto-fix: false]`
  - godot: Check if comments end with a dot `[fast: true, auto-fix: true]`
  - godox: Tool for detection of FIXME, TODO and other comment keywords `[fast: true, auto-fix: false]`
  - goerr113: Golang linter to check the errors handling expressions `[fast: false, auto-fix: false]`
  - gofmt: Gofmt checks whether code was gofmt-ed. By default this tool runs with -s option to check for code simplification `[fast: true, auto-fix: true]`
  - gofumpt: Gofumpt checks whether code was gofumpt-ed. `[fast: true, auto-fix: true]`
  - goheader: Checks is file header matches to pattern `[fast: true, auto-fix: false]`
  - goimports: In addition to fixing imports, goimports also formats your code in the same style as gofmt. `[fast: true, auto-fix: true]`
  - gomnd: An analyzer to detect magic numbers. `[fast: true, auto-fix: false]`
  - gomoddirectives: Manage the use of 'replace', 'retract', and 'excludes' directives in go.mod. `[fast: true, auto-fix: false]`
  - gomodguard: Allow and block list linter for direct Go module dependencies. This is different from depguard where there are different block types for example version constraints and module recommendations. `[fast: true, auto-fix: false]`
  - goprintffuncname: Checks that printf-like functions are named with `f` at the end `[fast: true, auto-fix: false]`
  - gosec (gas): Inspects source code for security problems `[fast: false, auto-fix: false]`
  - gosimple (megacheck): Linter for Go source code that specializes in simplifying a code `[fast: false, auto-fix: false]`
  - govet (vet, vetshadow): Vet examines Go source code and reports suspicious constructs, such as Printf calls whose arguments do not align with the format string `[fast: false, auto-fix: false]`
  - ifshort: Checks that your code uses short syntax for if-statements whenever possible `[fast: true, auto-fix: false]`
  - importas: Enforces consistent import aliases `[fast: false, auto-fix: false]`
  - ineffassign: Detects when assignments to existing variables are not used `[fast: true, auto-fix: false]`
  - ireturn: Accept Interfaces, Return Concrete Types `[fast: false, auto-fix: false]`
  - lll: Reports long lines `[fast: true, auto-fix: false]`
  - makezero: Finds slice declarations with non-zero initial length `[fast: false, auto-fix: false]`
  - misspell: Finds commonly misspelled English words in comments `[fast: true, auto-fix: true]`
  - nakedret: Finds returns in functions greater than a specified function length `[fast: true, auto-fix: false]`
  - nestif: Reports deeply nested if statements `[fast: true, auto-fix: false]`
  - nilerr: Finds the code that returns nil even if it checks that the error is not nil. `[fast: false, auto-fix: false]`
  - nilnil: Checks that there is no simultaneous return of `nil` error and an bad value. `[fast: false, auto-fix: false]`
  - nlreturn: nlreturn checks for a new line before return and branch statements to increase code clarity `[fast: true, auto-fix: false]`
  - noctx: noctx finds sending http request without context.Context `[fast: false, auto-fix: false]`
  - nolintlint: Reports ill-formed or insufficient nolint directives `[fast: true, auto-fix: false]`
  - paralleltest: paralleltest detects missing usage of t.Parallel() method in your Go test `[fast: true, auto-fix: false]`
  - predeclared: find code that shadows one of Go's predeclared identifiers `[fast: true, auto-fix: false]`
  - promlinter: Check Prometheus metrics naming via promlint `[fast: true, auto-fix: false]`
  - revive: Fast, configurable, extensible, flexible, and beautiful linter for Go. Drop-in replacement of golint. `[fast: false, auto-fix: false]`
  - rowserrcheck: checks whether Err of rows is checked successfully `[fast: false, auto-fix: false]`
  - sqlclosecheck: Checks that sql.Rows and sql.Stmt are closed. `[fast: false, auto-fix: false]`
  - staticcheck (megacheck): Staticcheck is a go vet on steroids, applying a ton of static analysis checks `[fast: false, auto-fix: false]`
  - structcheck: Finds unused struct fields `[fast: false, auto-fix: false]`
  - stylecheck: Stylecheck is a replacement for golint `[fast: false, auto-fix: false]`
  - tagliatelle: Checks the struct tags. `[fast: true, auto-fix: false]`
  - tenv: tenv is analyzer that detects using os.Setenv instead of t.Setenv since Go1.17 `[fast: false, auto-fix: false]`
  - testpackage: linter that makes you use a separate \_test package `[fast: true, auto-fix: false]`
  - thelper: thelper detects golang test helpers without t.Helper() call and checks the consistency of test helpers `[fast: false, auto-fix: false]`
  - tparallel: tparallel detects inappropriate usage of t.Parallel() method in your Go test codes `[fast: false, auto-fix: false]`
  - typecheck: Like the front-end of a Go compiler, parses and type-checks Go code `[fast: false, auto-fix: false]`
  - unconvert: Remove unnecessary type conversions `[fast: false, auto-fix: false]`
  - unparam: Reports unused function parameters `[fast: false, auto-fix: false]`
  - unused (megacheck): Checks Go code for unused constants, variables, functions and types `[fast: false, auto-fix: false]`
  - varcheck: Finds unused global variables and constants `[fast: false, auto-fix: false]`
  - varnamelen: checks that the length of a variable's name matches its scope `[fast: false, auto-fix: false]`
  - wastedassign: wastedassign finds wasted assignment statements. `[fast: false, auto-fix: false]`
  - whitespace: Tool for detection of leading and trailing whitespace `[fast: true, auto-fix: true]`
  - wrapcheck: Checks that errors returned from external packages are wrapped `[fast: false, auto-fix: false]`
  - wsl: Whitespace Linter - Forces you to use empty lines! `[fast: true, auto-fix: false]`

  Deactivated by your configuration linters:

  - gochecknoglobals: check that no global variables exist `[fast: true, auto-fix: false]`
  - prealloc: Finds slice declarations that could potentially be preallocated `[fast: true, auto-fix: false]`

  Deprecated linters:

  - golint: (since v1.41.0) - Golint differs from gofmt. Gofmt reformats Go source code, whereas golint prints out style mistakes `[fast: false, auto-fix: false]`
  - interfacer: (since v1.38.0) - Linter that suggests narrower interface types `[fast: false, auto-fix: false]`
  - maligned: (since v1.38.0) - Tool to detect Go structs that would take less memory if their fields were sorted `[fast: false, auto-fix: false]`
  - scopelint: (since v1.39.0) - Scopelint checks for unpinned variables in go programs `[fast: true, auto-fix: false]`

### 4.5. Troubleshoot

Issue [#14](https://github.com/actions/setup-go/issues/14) - Add $GOPATH/bin to $PATH.

## 5. Shellcheck

[shellcheck](https://github.com/koalaman/shellcheck) - a shell script static analysis tool.

### 5.1. Requirements

`apt` package management system for installing, upgrading, configuring, and removing software.

### 5.2. Install

```bash
sudo apt install shellcheck
```

### 5.3. Usage

```bash
shellcheck *.sh
```

### 5.4. Configuration

Unless --norc is used, ShellCheck will look for a file [.shellcheckrc](https://github.com/koalaman/shellcheck/issues/72) or shellcheckrc in the script's directory and each parent directory. If found, it will read key=value pairs from it and treat them as file-wide directives.

An example for .shellcheckrc:

```bash
# Don't suggest using -n in [ $var ]
disable=SC2244

# Allow using `which` since it gives full paths and is common enough
disable=SC2230
```

## 6. Commitlint

[commitlint](https://github.com/conventional-changelog/commitlint) checks if your commit messages meet the [conventional commit](https://www.conventionalcommits.org/en/v1.0.0/) format.

Related:

- [commitlint-github-action](https://github.com/wagoid/commitlint-github-action)
- [commitlint-azure-pipelines-cli](https://yarnpkg.com/package/commitlint-azure-pipelines-cli)

### 6.1. Requirements

- NPM 6.14.14 or higher.
- Node 12+

### 6.2. Install

```bash
sudo npm install -g @commitlint/cli @commitlint/config-conventional @commitlint/format
```

### 6.3. Uninstall

```bash
sudo npm uninstall -g @commitlint/cli @commitlint/config-conventional @commitlint/format
```

### 6.4. Usage

```bash
# Lint last commit from history
commitlint --from=HEAD~1 --config ".commitlintrc.js"

# Lint all commits from history
commitlint --from "$(git rev-parse --abbrev-ref remotes/origin/HEAD)" --to "$(git rev-parse --abbrev-ref HEAD)" --config ".commitlintrc.js"
```

### 6.5. Configuration

[Shared configuration](https://github.com/conventional-changelog/commitlint#shared-configuration) lists a number of shared configurations available to install and use with `commitlint`.

[Configuration file](https://github.com/conventional-changelog/commitlint#config) is picked up from:

- .commitlintrc
- .commitlintrc.json
- .commitlintrc.yaml
- .commitlintrc.yml
- .commitlintrc.js
- .commitlintrc.cjs
- .commitlintrc.ts
- commitlint.config.js
- commitlint.config.cjs
- commitlint.config.ts

[Reference configuration](https://github.com/conventional-changelog/commitlint/blob/master/docs/reference-configuration.md) for `.commitlintrc.js`:

```js
const Configuration = {
  /*
   * Resolve and load @commitlint/config-conventional from node_modules.
   * Referenced packages must be installed
   */
  extends: ["@commitlint/config-conventional"],
  /*
   * Resolve and load conventional-changelog-atom from node_modules.
   * Referenced packages must be installed
   */
  parserPreset: "conventional-changelog-atom",
  /*
   * Resolve and load @commitlint/format from node_modules.
   * Referenced package must be installed
   */
  formatter: "@commitlint/format",
  /*
   * Any rules defined here will override rules from @commitlint/config-conventional
   */
  rules: {
    "type-enum": [2, "always", ["foo"]],
  },
  /*
   * Functions that return true if commitlint should ignore the given message.
   */
  ignores: [(commit) => commit === ""],
  /*
   * Whether commitlint uses the default ignore rules.
   */
  defaultIgnores: true,
  /*
   * Custom URL to show upon failure
   */
  helpUrl:
    "https://github.com/conventional-changelog/commitlint/#what-is-commitlint",
  /*
   * Custom prompt configs
   */
  prompt: {
    messages: {},
    questions: {
      type: {
        description: "please input type:",
      },
    },
  },
}

module.exports = Configuration
```

## 7. Makrdownlint

[makrdownlint](https://github.com/markdownlint/markdownlint) a tool to check markdown files and flag style issues.

Related:

[makrdownlint - npm](https://github.com/DavidAnson/markdownlint)

### 7.1. Requirements

- NPM 6.14.14 or higher.
- Node 12+

### 7.2. Install

```bash
sudo npm install -g markdownlint markdownlint-cli
```

### 7.3. Uninstall

```bash
# Global & Local
sudo npm uninstall -g markdownlint && npm uninstall markdownlint
```

### 7.4. Usage

```bash
markdownlint -j -c '.markdownlint.json' -i ".markdownlintignore" '**/*.md'
```

### 7.5. Configuration

Markdownlint has several options you can configure.

- Resource file

`.markdownlint.json`

```json
{
  "default": true,
  "MD013": false,
  "MD024": {
    "allow_different_nesting": true
  },
  "MD007": {
    "indent": 2
  }
}
```

- Ignore file

`.markdownlintignore`

```txt
vendor/
node_modules/
CHANGELOG.md
```

## 8. Yamllint

[yamllint](https://github.com/adrienverge/yamllint) a linter for YAML files.

yamllint does not only check for syntax validity, but for weirdness like key repetition and cosmetic problems such as lines length, trailing spaces, indentation, etc.

### 8.1. Requirements

Python 3.7 or higher.

### 8.2. Install

Using pip, the Python package manager:

```bash
pip install --user yamllint
```

### 8.3. Usage

```bash
# Lint all YAML files in a directory
yamllint .

# Use a custom lint configuration
yamllint -c /path/to/myconfig file-to-lint.yaml

# Use a pre-defined lint configuration
yamllint -d relaxed file.yaml
```

### 8.4. Configuration

yamllint uses a set of rules to check source files for problems. Each rule is independent from the others, and can be turned on, turned off or tweaked. All these settings can be gathered in a [configuration file](https://yamllint.readthedocs.io/en/stable/configuration.html).

To use a custom configuration file, use the `-c` option:

If `-c` is not provided, yamllint will look for a configuration file in the following locations (by order of preference):

- .yamllint, .yamllint.yaml or .yamllint.yml in the current working directory
- the file referenced by $YAMLLINT_CONFIG_FILE, if set
- $XDG_CONFIG_HOME/yamllint/config
- ~/.config/yamllint/config

```yml
---
extends: default

locale: en_US.UTF-8

ignore: |
  ../../vendor/
  ../../node_modules/
  *.template.yaml

rules:
  indentation: enable
  line-length:
    max: 100
    allow-non-breakable-words: true
    allow-non-breakable-inline-mappings: false
```

## 9. Jsonlint

[jsonlint](https://github.com/zaach/jsonlint) a pure JavaScript version of the service provided at [jsonlint.com](https://jsonlint.com/).

### 9.1. Requirements

- NPM 6.14.14 or higher.
- Node 12+

### 9.2. Install

Install jsonlint with npm to use the command line interface:

```bash
# Local
npm install jsonlint

# Global
sudp npm install -g jsonlint
```

### 9.3. Uninstall

```bash
# Global & Local
sudo npm uninstall -g jsonlint && npm uninstall jsonlint
```

### 9.4. Usage

```bash
# Run json linting
find . -type d \( -name node_modules -o -name vendor -o -regex ".*(package.json|package-lock.json)($|.*)" \) -prune -false -o -regex "*.json" -exec jsonlint -c {} \;

# Overwrite the file
jsonlint --in-place *.json
```

## 10. Remark

[remark-lint](https://github.com/remarkjs/remark-lint) is plugins to lint Markdown.

### 10.1. Requirements

- NPM 6.14.14 or higher.
- Node 12+

### 10.2. Install

```bash
# Local
npm install remark-cli remark-preset-lint-recommended

# Global
sudo npm i -g remark-cli remark-preset-lint-recommended
```

### 10.3. Uninstall

```bash
# Global & Local
sudo npm uninstall -g remark && npm uninstall remark
```

### 10.4. Usage

```bash
remark readme.md
```

### 10.5. Configuration

[remark-lint config](https://github.com/remarkjs/remark-lint#configure) has own mechanism to use configuration files such as `.remarkrc`, `.remarkrc.yml`, or `package.json`.

For example, you can configure plugins via the following `.remarkrc.yml` file:

- Resource file

  ```yml
  ---
  plugins:
    # Presets
    remark-preset-lint-consistent: true
    remark-preset-lint-markdown-style-guide: true
    remark-preset-lint-recommended: true
    remark-validate-links: true

    # Rules
    remark-lint-list-item-indent: space
    remark-lint-maximum-line-length: 100
  ```

- Ignore file

  ```txt
  linter:
    remark_lint:
      ignore-path: vendor
  ```

## 11. Dockerfilelint

[dockerfilelint](https://github.com/replicatedhq/dockerfilelint) a linter for Docker files. dockerfilelint is an node module that analyzes a Dockerfile and looks for common mistakes and helps enforce best practices.

### 11.1. Requirements

- NPM 6.14.14 or higher.
- Node 12+

### 11.2. Install

```bash
sudo npm install -g dockerfilelint
```

### 11.3. Usage

- CLI:

  ```bash
  ./bin/dockerfilelint <path/to/Dockerfile>
  ```

### 11.4. Configuration

You can configure the linter by creating a `.dockerfilelintrc` with the following syntax:

```yaml
rules:
  uppercase_commands: off
```

The keys for the rules can be any file in the /lib/reference.js file. At this time, it's only possible to disable rules. They are all enabled by default.

The following rules are supported:

```txt
required_params
uppercase_commands
from_first
invalid_line
sudo_usage
apt-get_missing_param
apt-get_recommends
apt-get-upgrade
apt-get-dist-upgrade
apt-get-update_require_install
apkadd-missing_nocache_or_updaterm
apkadd-missing-virtual
invalid_port
invalid_command
expose_host_port
label_invalid
missing_tag
latest_tag
extra_args
missing_args
add_src_invalid
add_dest_invalid
invalid_workdir
invalid_format
apt-get_missing_rm
deprecated_in_1.13
```
