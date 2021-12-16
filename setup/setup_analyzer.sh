#!/bin/bash
#
# Perform dependency installation.

# -x: print a trace (debug)
# -u: treat unset variables
# -o pipefail: return value of a pipeline
# -o posix: match the standard
set -uo pipefail

# Constant variables

PATH_TOPLEVEL="$(git rev-parse --show-superproject-working-tree --show-toplevel | head -1)"
readonly PATH_TOPLEVEL
PATH_SCRIPTDIR="$(dirname "$(realpath "$0")")"
readonly PATH_SCRIPTDIR
readonly TASK="Validate - analyzer"

# Internal functions

function printer() {
  echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

function monitor() {
  local task="$1"
  local package="$2"
  local status="$3"

  if ((status == 0)); then
    printer "🟢 [${task}] succeeded ${package}"
  else
    printer "🟠 [${task}] failed ${package}"
  fi
}

function is_file() {
  if [[ -f "$1" ]]; then
    return 0
  fi

  return 1
}

function is_dir() {
  if [[ -d "$1" ]]; then
    return 0
  fi

  return 1
}

function install_apt_dependency() {
  local package="$1"

  local -i result=0

  if ! command -v "${package}" &> /dev/null; then
    sudo apt install -y -qq "${package}"
    ((result = $?))
  fi

  monitor "${TASK}" "${package}" "${result}"

  return "${result}"
}

function install_pip_dependency() {
  local package="$1"

  local -i result=0

  if ! command -v "${package}" &> /dev/null; then
    sudo pip install -q "${package}"
    ((result = $?))
  fi

  monitor "${TASK}" "${package}" "${result}"

  return "${result}"
}

function install_npm_dependency() {
  local package="$1"

  local -i result=0

  if ! npm list "${package}"@latest -g --depth=0 &> /dev/null; then
    sudo -H npm i --silent -g "${package}"@latest --unsafe-perm
    ((result |= $?))
  fi

  monitor "${TASK}" "${package}" "${result}"

  return "${result}"
}

function install_curl_dependency() {
  local package="$1"
  local url="$2"

  local -i result=0

  if ! command -v "${package}" &> /dev/null; then
    curl -sS "${url}" | bash
    ((result = $?))
    export PATH="${HOME}"/.local/bin:"${PATH}"
  fi

  monitor "${TASK}" "${package}" "${result}"

  return "${result}"
}

function install_go_dependency() {
  local package="$1"

  local -i result=0

  local file="go.mod"
  if is_file "${file}"; then
    # FIXME https://github.com/actions/setup-go/issues/14
    export PATH="${HOME}"/go/bin:/usr/local/go/bin:"${PATH}"

    if ! command -v "${package}" &> /dev/null; then
      go install "${package}"
      ((result = $?))
    fi

    go mod vendor
  fi

  monitor "${TASK}" "${package}" "${result}"

  return "${result}"
}

function create_hook() {
  local hook="$1"
  local command="$2"

  local -i result=0

  local dir=".husky"
  if ! is_dir "${dir}"; then
    npx husky install
    ((result |= $?))
  fi

  local file="${dir}""/""${hook}"
  if ! is_file "${file}"; then
    npx husky add "${file}" "${command}"
    ((result |= $?))
  fi

  monitor "${TASK}" "${file}" "${result}"

  return "${result}"
}

function initialize() {
  find "${PATH_SCRIPTDIR}""/../analyzer" -type f -name '.??*' -exec cp -n {} "${PATH_TOPLEVEL}" \;
  find "${PATH_SCRIPTDIR}""/../analyzer" -type f -name 'CPPLINT.cfg' -exec cp -n {} "${PATH_TOPLEVEL}" \;
}

function cleanup() {
  # Clean apt
  sudo apt autoremove && sudo apt autoclean && sudo apt clean
  rm -rf /var/lib/apt/lists/*

  # Clean npm
  npm cache clean --force
}

# Control flow logic

cd "${PATH_TOPLEVEL}" || exit

declare -i retval=0

# Install apt dependencies

install_apt_dependency licensecheck
((retval |= $?))

install_apt_dependency shellcheck
((retval |= $?))

install_apt_dependency cppcheck
((retval |= $?))

install_apt_dependency clang-tools
((retval |= $?))

install_apt_dependency clang-tidy
((retval |= $?))

install_apt_dependency clang-format
((retval |= $?))

install_apt_dependency valgrind
((retval |= $?))

# Install pip dependencies

install_pip_dependency scan-build
((retval |= $?))

install_pip_dependency codespell
((retval |= $?))

install_pip_dependency cpplint
((retval |= $?))

install_pip_dependency cmake_format
((retval |= $?))

install_pip_dependency yamllint
((retval |= $?))

# Install npm dependencies

install_npm_dependency npm-run-all
((retval |= $?))

install_npm_dependency alex
((retval |= $?))

install_npm_dependency prettier
((retval |= $?))

install_npm_dependency jsonlint
((retval |= $?))

install_npm_dependency remark-cli
((retval |= $?))

install_npm_dependency remark-preset-lint-markdown-style-guide
((retval |= $?))

install_npm_dependency remark-preset-lint-recommended
((retval |= $?))

install_npm_dependency remark-preset-lint-consistent
((retval |= $?))

install_npm_dependency remark-lint-list-item-indent
((retval |= $?))

install_npm_dependency remark-lint-maximum-line-length
((retval |= $?))

install_npm_dependency remark-lint-ordered-list-marker-value
((retval |= $?))

install_npm_dependency remark-lint-emphasis-marker
((retval |= $?))

install_npm_dependency remark-lint-strong-marker
((retval |= $?))

install_npm_dependency markdownlint
((retval |= $?))

install_npm_dependency markdownlint-cli
((retval |= $?))

install_npm_dependency markdown-link-check
((retval |= $?))

install_npm_dependency markdown-spellcheck
((retval |= $?))

install_npm_dependency @commitlint/cli
((retval |= $?))

install_npm_dependency @commitlint/config-conventional
((retval |= $?))

install_npm_dependency @commitlint/format
((retval |= $?))

install_npm_dependency semantic-release
((retval |= $?))

install_npm_dependency semantic-commitlint
((retval |= $?))

install_npm_dependency semantic-release-commitlint
((retval |= $?))

install_npm_dependency semantic-release-ado
((retval |= $?))

install_npm_dependency @semantic-release/npm
((retval |= $?))

install_npm_dependency @semantic-release/git
((retval |= $?))

install_npm_dependency @semantic-release/changelog
((retval |= $?))

install_npm_dependency @semantic-release/error
((retval |= $?))

install_npm_dependency @semantic-release/github
((retval |= $?))

install_npm_dependency @semantic-release/commit-analyzer
((retval |= $?))

install_npm_dependency @semantic-release/release-notes-generator
((retval |= $?))

install_npm_dependency husky
((retval |= $?))

install_npm_dependency pre-commit
((retval |= $?))

create_hook pre-commit "npm test"
((retval |= $?))

install_npm_dependency commit-msg
((retval |= $?))

create_hook commit-msg "npx --no-install commitlint --edit"
((retval |= $?))

# Install curl dependencies

install_curl_dependency shfmt https://webinstall.dev/shfmt
((retval |= $?))

# Install go dependencies

install_go_dependency github.com/golangci/golangci-lint/cmd/golangci-lint@latest
((retval = $?))

# Uncomment the following line to clean setup
# cleanup

initialize

exit "${retval}"
