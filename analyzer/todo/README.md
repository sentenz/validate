# `/todo`

- [1. Clang Analyzer](#1-clang-analyzer)
  - [1.1. Requirements](#11-requirements)
  - [1.2. Install](#12-install)
  - [1.3. Usage](#13-usage)
  - [1.4. Configuration](#14-configuration)
- [2. Valgrind](#2-valgrind)
  - [2.1. Requirements](#21-requirements)
  - [2.2. Install](#22-install)
  - [2.3. Usage](#23-usage)
  - [2.4. Configuration](#24-configuration)

## 1. Clang Analyzer

[scan-build](https://github.com/rizsotto/scan-build) is a package designed to wrap a build so that all calls to gcc/clang are intercepted and logged into a compilation database and/or piped to the clang static analyzer. Includes intercept-build tool, which logs the build, as well as scan-build tool, which logs the build and runs the clang static analyzer on it.

See [scan-build docs](http://clang-analyzer.llvm.org/scan-build.html)

### 1.1. Requirements

Python 3.7 or higher.

`pip` is the package installer for Python. You can use pip to install packages from the Python Package Index and other indexes.

### 1.2. Install

It's available from the Python Package Index.

```bash
pip install scan-build
```

### 1.3. Usage

Generally speaking, the `intercept-build` and `analyze-build` tools together does the same job as `scan-build` does. So, you can expect the same output from this line as scan-build would do:

```bash
# To run the Clang static analyzer against a project goes like this:
scan-build <your build command>

# To generate a compilation database file goes like this:
intercept-build <your build command>

# To run the Clang static analyzer against a project with compilation database goes like this:
analyze-build
```

### 1.4. Configuration

```bash

```

## 2. Valgrind

[Valgrind](https://www.valgrind.org/) is an instrumentation framework for building dynamic analysis tools. There are Valgrind tools that can automatically detect many memory management and threading bugs, and profile your programs in detail.

The Valgrind distribution currently includes seven production-quality tools: a memory error detector, two thread error detectors, a cache and branch-prediction profiler, a call-graph generating cache and branch-prediction profiler, and two different heap profilers.

Related:

- [valgrind - github](https://github.com/tklengyel/valgrind)

### 2.1. Requirements

`apt` package management system for installing, upgrading, configuring, and removing software.

### 2.2. Install

```bash
sudo apt install -y valgrind
```

### 2.3. Usage

Valgrind [manual-core](https://valgrind.org/docs/manual/manual-core.html) describes the Valgrind core services, command-line options and behaviours.

```bash
# Run valgrind memory error detector
valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes --show-reachable=yes --error-limit=no -q ./<executable>
```

### 2.4. Configuration

When running valgrind, it will check in the current directory for a file named `~/.valgrindrc` or `./.valgrindrc` (or a file specified via `--suppressions=<filename>`).

```bash
# Generating valgrind memory leak suppression file
valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes --show-reachable=yes --error-limit=no --gen-suppressions=all --log-file=valgrind.log ./<executable>
```

Example of a `.valgrindrc` file containing:

```txt
--memcheck:leak-check=full
--show-reachable=yes
--suppressions=/home/david/devel/wxGTK-2.8.12.supp
--suppressions=/home/david/devel/wxGTK-2.9.supp
```
