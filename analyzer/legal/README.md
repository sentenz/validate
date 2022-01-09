# `/legal`

- [1. Licensecheck](#1-licensecheck)
  - [1.1. Requirements](#11-requirements)
  - [1.2. Install](#12-install)
  - [1.3. Usage](#13-usage)
- [2. Licensing](#2-licensing)
  - [2.1. Requirements](#21-requirements)
  - [2.2. Install](#22-install)
  - [2.3. Usage](#23-usage)

## 1. Licensecheck

The [licensecheck](https://github.com/google/licensecheck) package scans source texts for known licenses. The design aims never to give a false positive. It also reports matches of known license URLs.

### 1.1. Requirements

`apt` package management system for installing, upgrading, configuring, and removing software.

### 1.2. Install

```bash
sudo apt install -y licensecheck
```

### 1.3. Usage

```bash
licensecheck --check '.*' --recursive --deb-machine --lines 0 *

licensecheck --copyright --deb-machine --recursive --lines 0 --check '.*' --ignore '.*\.ttf$' -- *
```

`.licensecheckignore`

```txt
^.*[^.]{5}$                                 match file without extension
|                                           or
[^\w](\.|\/\.)\w.+                          match hidden file
|                                           or
^.*\.(exe|txt|sh|md|log|js|json|mod|sum)$   match file extension
|                                           or
.*(vendor|scripts|node_modules)($|.*)       match directory
```

`.licensecheckrc`

```txt
^.*\.(go)$                                  match file extension
```

## 2. Licensing

[licensing](https://code.tools/man/1/licensing/) - a program for adding license notices to files.

### 2.1. Requirements

`apt` package management system for installing, upgrading, configuring, and removing software.

### 2.2. Install

```bash
sudo apt install -y licenseutils
```

### 2.3. Usage

```bash
licensing --help
```
