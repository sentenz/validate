# `/format`

- [`/format`](#format)
  - [Clang-Format](#clang-format)
    - [Requirements](#requirements)
    - [Install](#install)
      - [apt](#apt)
      - [python wrapper](#python-wrapper)
      - [npm wrapper](#npm-wrapper)
    - [Usage](#usage)
    - [Configuration](#configuration)
      - [Resource file](#resource-file)
      - [Ignore file](#ignore-file)
  - [gofmt](#gofmt)
    - [Requirements](#requirements-1)
    - [Install](#install-1)
    - [Usage](#usage-1)
  - [shfmt](#shfmt)
    - [Requirements](#requirements-2)
    - [Install](#install-2)
      - [Binary](#binary)
    - [Usage](#usage-2)
    - [Configuration](#configuration-1)
  - [Prettier](#prettier)
    - [Requirements](#requirements-3)
    - [Install](#install-3)
    - [Usage](#usage-3)
    - [Configuration](#configuration-2)

## Clang-Format

A tool to format C/C++/Java/JavaScript/Objective-C/Protobuf/C# code. Ensuring that changes to your code are properly formatted is an important part of your development workflow.

Related:

[clang-format](https://clang.llvm.org/docs/ClangFormatStyleOptions.html)
[clang-format - python](https://github.com/Sarcasm/run-clang-format)
[clang-format - npm](https://github.com/angular/clang-format)

### Requirements

Require:

- Python to be globally available.
- `apt` or `npm` package manager.

### Install

#### apt

```bash
sudo apt install -y clang-format
```

#### python wrapper

Copy [run-clang-format.py](https://github.com/Sarcasm/run-clang-format/blob/master/run-clang-format.py) script into your project.

#### npm wrapper

node.js module which wraps the native clang-format executable.

```bash
sudo npm install -g clang-format
clang-format -help
```

### Usage

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

### Configuration

#### Resource file

A way to get a valid `.clang-format` file containing all configuration options of a certain predefined style is:

```bash
clang-format -style=google -dump-config > .clang-format
```

another way is to use the [clang-format configurator](https://zed0.co.uk/clang-format-configurator/).

Example:

```txt
---
BasedOnStyle: Google
AlignAfterOpenBracket: Align
AlignConsecutiveMacros: 'true'
AlignConsecutiveAssignments: 'true'
AlignConsecutiveDeclarations: 'false'
AlignEscapedNewlines: Left
AlignOperands: 'true'
AlignTrailingComments: 'true'
AllowAllArgumentsOnNextLine: 'false'
AllowAllConstructorInitializersOnNextLine: 'false'
AllowAllParametersOfDeclarationOnNextLine: 'false'
AllowShortBlocksOnASingleLine: 'false'
AllowShortCaseLabelsOnASingleLine: 'false'
AllowShortFunctionsOnASingleLine: Empty
AllowShortIfStatementsOnASingleLine: Never
AllowShortLoopsOnASingleLine: 'false'
AlwaysBreakBeforeMultilineStrings: 'false'
BinPackArguments: 'false'
BinPackParameters: 'false'
BreakBeforeTernaryOperators: 'true'
BreakConstructorInitializers: BeforeColon
BreakInheritanceList: BeforeComma
ColumnLimit: '100'
CommentPragmas: 'NOLINT:.*'
CompactNamespaces: 'false'
ConstructorInitializerAllOnOneLineOrOnePerLine: 'false'
Cpp11BracedListStyle: 'true'
FixNamespaceComments: 'true'
IndentCaseLabels: 'true'
IndentPPDirectives: BeforeHash
IndentWidth: '2'
KeepEmptyLinesAtTheStartOfBlocks: 'false'
Language: Cpp
MaxEmptyLinesToKeep: '1'
NamespaceIndentation: All
PointerAlignment: Left
ReflowComments: 'true'
SortIncludes: 'true'
SortUsingDeclarations: 'true'
SpaceAfterTemplateKeyword: 'false'
SpaceBeforeAssignmentOperators: 'true'
SpaceBeforeParens: ControlStatements
SpaceInEmptyParentheses: 'false'
SpacesInAngles: 'false'
SpacesInCStyleCastParentheses: 'false'
SpacesInContainerLiterals: 'false'
SpacesInParentheses: 'false'
SpacesInSquareBrackets: 'false'
TabWidth: '2'
UseTab: Never

# Specify the #include statement order.  This implements the order mandated by
# the Google C++ Style Guide: related header, C headers, C++ headers, library
# headers, and finally the project headers.
#
# To obtain updated lists of system headers used in the below expressions, see:
# http://stackoverflow.com/questions/2027991/list-of-standard-header-files-in-c-and-c/2029106#2029106.
IncludeCategories:
  - Regex:    '^<clang-format-priority-15>$'
    Priority: 15
  - Regex:    '^<clang-format-priority-25>$'
    Priority: 25
  - Regex:    '^<clang-format-priority-35>$'
    Priority: 35
  - Regex:    '^<clang-format-priority-45>$'
    Priority: 45
  # C system headers.
  - Regex:    '^[<"](aio|arpa/inet|assert|complex|cpio|ctype|curses|dirent|dlfcn|errno|fcntl|fenv|float|fmtmsg|fnmatch|ftw|glob|grp|iconv|inttypes|iso646|langinfo|libgen|limits|locale|math|monetary|mqueue|ndbm|netdb|net/if|netinet/in|netinet/tcp|nl_types|poll|pthread|pwd|regex|sched|search|semaphore|setjmp|signal|spawn|stdalign|stdarg|stdatomic|stdbool|stddef|stdint|stdio|stdlib|stdnoreturn|string|strings|stropts|sys/ipc|syslog|sys/mman|sys/msg|sys/resource|sys/select|sys/sem|sys/shm|sys/socket|sys/stat|sys/statvfs|sys/time|sys/times|sys/types|sys/uio|sys/un|sys/utsname|sys/wait|tar|term|termios|tgmath|threads|time|trace|uchar|ulimit|uncntrl|unistd|utime|utmpx|wchar|wctype|wordexp)\.h[">]$'
    Priority: 20
  # C++ system headers (as of C++17).
  - Regex:    '^[<"](algorithm|any|array|atomic|bitset|cassert|ccomplex|cctype|cerrno|cfenv|cfloat|charconv|chrono|cinttypes|ciso646|climits|clocale|cmath|codecvt|complex|condition_variable|csetjmp|csignal|cstdalign|cstdarg|cstdbool|cstddef|cstdint|cstdio|cstdlib|cstring|ctgmath|ctime|cuchar|cwchar|cwctype|deque|exception|execution|filesystem|forward_list|fstream|functional|future|initializer_list|iomanip|ios|iosfwd|iostream|istream|iterator|limits|list|locale|map|memory|memory_resource|mutex|new|numeric|optional|ostream|queue|random|ratio|regex|scoped_allocator|set|shared_mutex|sstream|stack|stdexcept|streambuf|string|string_view|strstream|system_error|thread|tuple|type_traits|typeindex|typeinfo|unordered_map|unordered_set|utility|valarray|variant|vector)[">]$'
    Priority: 30
  # Other libraries' h files (with angles).
  - Regex:    '^<'
    Priority: 40
  # Project's h files.
  - Regex:    '^"s_'
    Priority: 50
  # Other libraries' h files (with quotes).
  - Regex:    '^"'
    Priority: 60
  # The rest
  - Regex:    '.*'
    Priority: 70
```

#### Ignore file

These exclude rules can be put in a `.clang-format-ignore` file, which also supports comments:

```txt
build/*
docs/*
external/*
third_party/*
node_modules/*
vendor/*
```

## gofmt

### Requirements

Go 1.15 or higher.

### Install

Built-in

### Usage

```bash
# To run go formatter recursively on all project’s files simply use
gofmt -s -w .

# To ignore folders from formation run
find . -type d \( -name node_modules -o -name .vscode -o -name vendor \) -prune -false -o -regex "${RE_FORMAT_FIND}" -exec gofmt -s -l -w {} \; &> "${FILE_LOG}"
```

## shfmt

[shfmt](https://github.com/mvdan/sh) formats shell programs.

Related:

[shfmt - Manuel Page](https://www.mankier.com/1/shfmt#)

### Requirements

Requires Go 1.15 or higher.

### Install

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

#### Binary

Binary [releases](https://github.com/mvdan/sh/releases).

### Usage

Do not use the `-s` option to simplify the code, as this violates the [Shell Style Guide](https://google.github.io/styleguide/shellguide.html).

```bash
# Run shell formatting
shfmt -l -kp -sr -ci -i 2 -d .

# Write result to file instead of stdout
shfmt -kp -sr -ci -i 2 -w .
```

### Configuration

If any EditorConfig files are found, they will be used to apply formatting options. If any parser or printer flags are given to the tool, no EditorConfig files will be used.

Below is an example `.editorconfig` file setting end-of-line and indentation styles for Python and JavaScript files.

```conf
[*.sh]
# like -i=2
indent_style = space
indent_size = 2
```

## Prettier

[Prettier](https://github.com/prettier/prettier) is an opinionated code formatter.

### Requirements

- NPM 6.14.14 or higher.
- Node 12+

### Install

```bash
# Local
npm install --save-dev prettier

# Global
sudo npm install -g prettier
```

### Usage

```bash
prettier [options] [file/dir/glob ...]
```

Examples:

```bash
prettier -w .
```

### Configuration

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
