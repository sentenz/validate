# `/legal`

- [Licensecheck](#licensecheck)
  - [Requirements](#requirements)
  - [Install](#install)
  - [Usage](#usage)
- [Licensing](#licensing)
  - [Requirements](#requirements-1)
  - [Install](#install-1)
  - [Usage](#usage-1)

## Licensecheck

The [licensecheck](https://github.com/google/licensecheck) package scans source texts for known licenses. The design aims never to give a false positive. It also reports matches of known license URLs.

### Requirements

`apt` package management system for installing, upgrading, configuring, and removing software.

### Install

```bash
sudo apt install -y licensecheck
```

### Usage

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

## Licensing

[licensing](https://code.tools/man/1/licensing/) - a program for adding license notices to files.

### Requirements

`apt` package management system for installing, upgrading, configuring, and removing software.

### Install

```bash
sudo apt install -y licenseutils
```

### Usage

```bash
licensing --help
```
