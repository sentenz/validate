# `/format`

- [1. Clang-Format](#1-clang-format)
  - [1.1. Requirements](#11-requirements)
  - [1.2. Install](#12-install)
    - [1.2.1. apt](#121-apt)
    - [1.2.2. python wrapper](#122-python-wrapper)
    - [1.2.3. npm wrapper](#123-npm-wrapper)
  - [1.3. Usage](#13-usage)
  - [1.4. Configuration](#14-configuration)
    - [1.4.1. Resource file](#141-resource-file)
    - [1.4.2. Ignore file](#142-ignore-file)
- [2. gofmt](#2-gofmt)
  - [2.1. Requirements](#21-requirements)
  - [2.2. Install](#22-install)
  - [2.3. Usage](#23-usage)
- [3. shfmt](#3-shfmt)
  - [3.1. Requirements](#31-requirements)
  - [3.2. Install](#32-install)
    - [3.2.1. Binary](#321-binary)
  - [3.3. Usage](#33-usage)
  - [3.4. Configuration](#34-configuration)
- [4. Prettier](#4-prettier)
  - [4.1. Requirements](#41-requirements)
  - [4.2. Install](#42-install)
  - [4.3. Usage](#43-usage)
  - [4.4. Configuration](#44-configuration)

## 1. Clang-Format

A tool to format C/C++/Java/JavaScript/Objective-C/Protobuf/C# code. Ensuring that changes to your code are properly formatted is an important part of your development workflow.

Related:

[clang-format](https://clang.llvm.org/docs/ClangFormatStyleOptions.html)
[clang-format - python](https://github.com/Sarcasm/run-clang-format)
[clang-format - npm](https://github.com/angular/clang-format)

### 1.1. Requirements

Require:

- Python to be globally available.
- `apt` or `npm` package manager.

### 1.2. Install

#### 1.2.1. apt

```bash
sudo apt install -y clang-format
```

#### 1.2.2. python wrapper

Copy [run-clang-format.py](https://github.com/Sarcasm/run-clang-format/blob/master/run-clang-format.py) script into your project.

#### 1.2.3. npm wrapper

node.js module which wraps the native clang-format executable.

```bash
sudo npm install -g clang-format
clang-format -help
```

### 1.3. Usage

Clang example:

```bash
# Run code formatting
clang-format -i *.cpp

# To format all .h, .c, .hpp, .cpp, .cu files together
find . -regex '.*\.\(cpp\|hpp\|cu\|c\|h\)' -exec clang-format -style=file -i {} \;
```

Python wrapper example:

```bash
# Run it recursively on directories, or specific files
./run-clang-format.py --recursive --in-place .

# It's possible to exclude paths from the recursive search
./run-clang-format.py -r \
    --exclude src/third_party \
    --exclude '*_test.cpp' \
    src include foo.cpp
```

Node wrapper example:

```bash
# Globing files
clang-format --glob=folder/**/*.js

# It's possible to exclude paths from the recursive search
./run-clang-format.py -r \
    --exclude src/third_party \
    --exclude '*_test.cpp' \
    src include foo.cpp
```

### 1.4. Configuration

#### 1.4.1. Resource file

A way to get a valid `.clang-format` file containing all configuration options of a certain predefined style is:

```bash
clang-format -style=google --dump-config > .clang-format
```

another way is to use the [clang-format configurator](https://zed0.co.uk/clang-format-configurator/).

#### 1.4.2. Ignore file

These exclude rules can be put in a `.clang-format-ignore` file, which also supports comments:

```txt
build/*
docs/*
external/*
third_party/*
node_modules/*
vendor/*
```

## 2. gofmt

### 2.1. Requirements

Go 1.15 or higher.

### 2.2. Install

Built-in

### 2.3. Usage

```bash
# To run go formatter recursively on all project’s files simply use
gofmt -s -w .

# To ignore folders from formation run
find . -type d \( -name node_modules -o -name .vscode -o -name vendor \) -prune -false -o -regex "${RE_FORMAT_FIND}" -exec gofmt -s -l -w {} \; &> "${FILE_LOG}"
```

## 3. shfmt

[shfmt](https://github.com/mvdan/sh) formats shell programs.

Related:

[shfmt - Manuel Page](https://www.mankier.com/1/shfmt#)

### 3.1. Requirements

Requires Go 1.15 or higher.

### 3.2. Install

shfmt is available as snap application. If your distribution has snap installed, you can install shfmt using command:

**Note** currently broken!

```bash
sudo snap install shfmt
```

The another way to install shfmt is by using the following one-liner command:

```bash
curl -sS https://webinstall.dev/shfmt | bash
export PATH="~/.local/bin:$PATH"
```

#### 3.2.1. Binary

Binary [releases](https://github.com/mvdan/sh/releases).

### 3.3. Usage

Do not use the `-s` option to simplify the code, as this violates the [Shell Style Guide](https://google.github.io/styleguide/shellguide.html).

```bash
# Run shell formatting
shfmt -l -kp -sr -ci -i 2 -d .

# Write result to file instead of stdout
shfmt -kp -sr -ci -i 2 -w .
```

### 3.4. Configuration

If any EditorConfig files are found, they will be used to apply formatting options. If any parser or printer flags are given to the tool, no EditorConfig files will be used.

Below is an example `.editorconfig` file setting end-of-line and indentation styles for Python and JavaScript files.

```conf
[*.sh]
# like -i=2
indent_style = space
indent_size = 2
```

## 4. Prettier

[Prettier](https://github.com/prettier/prettier) is an opinionated code formatter.

### 4.1. Requirements

- NPM 6.14.14 or higher.
- Node 12+

### 4.2. Install

```bash
# Local
npm install --save-dev prettier

# Global
sudo npm install -g prettier
```

### 4.3. Usage

```bash
prettier [options] [file/dir/glob ...]
```

Examples:

```bash
prettier -w .
```

### 4.4. Configuration

- [Configuration File](https://prettier.io/docs/en/configuration.html)

  The configuration file for configuration support with a handful of format [options](https://prettier.io/docs/en/options.html).

  Below is an example `.prettierrc.json` file.

  ```json
  {
    "trailingComma": "es5",
    "tabWidth": 2,
    "useTabs": false,
    "semi": false,
    "singleQuote": false
  }
  ```

- [Ignoring Code](https://prettier.io/docs/en/ignore.html)

  Use `.prettierignore` to ignore (i.e. not reformat) certain files and folders completely.

  Below is an example `.prettierignore` file.

  ```json
  # Ignore artifacts
  build
  vendor
  coverage

  # Ignore all HTML files
  *.html
  ```

  Use `prettier-ignore` comments to ignore parts of files.

  ```md
  <!-- prettier-ignore -->
  Do   not    format   this
  ```
