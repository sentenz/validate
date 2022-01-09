# `scripts/validate`

- [1. Install](#1-install)
- [2. Uninstall](#2-uninstall)
- [3. Update](#3-update)
- [4. Usage](#4-usage)

## 1. Install

How to link to documentation or integrate it into projects can be found here: [Usage](https://dev.azure.com/SMCEMEA/DE-PCD-General/_git/DE-PCD-General?path=/&version=GBmain&_a=contents&anchor=usage)

1. Add a Git Submodule

   ```bash
   clone --sparse --filter=blob:none --no-checkout --depth 1 -b <branch> <remote-respoitory-url> <relativ-local-folder-path>
   git submodule add -b <branch> <remote-respoitory-url> <relativ-local-folder-path>
   ```

   Example:

   ```bash
   git clone --sparse --filter=blob:none --no-checkout --depth 1 -b scripts/validate https://github.com/sentenz/essay.git scripts/validate
   git submodule add -b scripts/validate https://github.com/sentenz/essay.git scripts/validate
   ```

   Modify `.git/modules/scripts/validate/info/sparse-checkout`.

   ```bash
   git submodule absorbgitdirs
   git -C scripts/validate config core.sparseCheckout true
   echo 'validate/*' >> .git/modules/scripts/validate/info/sparse-checkout
   git submodule update --force --checkout scripts/validate
   ```

2. Pull a Git Submodule

   ```bash
   git submodule update --init --recursive
   ```

3. Status of a Git Submodule

   Check the status of a submodule:

   ```bash
   git submodule status
   ```

   The output should look like below:

   ```bash
   <sha> scripts/validate (heads/scripts/validate)
   ```

   If the output is empty, start from the beginning.

## 2. Uninstall

1. Remove a Git Submodule

   ```bash
   git submodule deinit scripts/validate
   git rm --cached scripts/validate
   ```

## 3. Update

1. Update a Git Submodule

   ```bash
   git submodule update --remote --recursive --merge
   ```

## 4. Usage

Run the `npm run setup` command to install the git submodules and to install the analyzer environment.

```bash
npm run setup
```
