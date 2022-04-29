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
readonly TASK_PRINT="Validate - analyzer"
readonly -a APT_PACKAGES=(
  licensecheck
  shellcheck
  cppcheck
  clang-tools
  clang-tidy
  clang-format
  valgrind
)
readonly -a PIP_PACKAGES=(
  scan-build
  codespell
  cpplint
  cmake_format
  yamllint
)
readonly -a NPM_PACKAGES=(
  alex
  prettier
  jsonlint
  remark-cli
  remark-preset-lint-markdown-style-guide
  remark-preset-lint-recommended
  remark-preset-lint-consistent
  remark-lint-list-item-indent
  remark-lint-maximum-line-length
  remark-lint-ordered-list-marker-value
  remark-lint-emphasis-marker
  remark-lint-strong-marker
  markdownlint
  markdownlint-cli
  markdown-link-check
  markdown-spellcheck
  @commitlint/cli
  @commitlint/config-conventional
  @commitlint/format
  husky
  pre-commit
  commit-msg
)

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

  monitor "${TASK_PRINT}" "${package}" "${result}"

  return "${result}"
}

function install_pip_dependency() {
  local package="$1"

  local -i result=0

  if ! command -v "${package}" &> /dev/null; then
    sudo pip install -q "${package}"
    ((result = $?))
  fi

  monitor "${TASK_PRINT}" "${package}" "${result}"

  return "${result}"
}

function install_npm_dependency() {
  local package="$1"

  local -i result=0

  if ! npm list "${package}"@latest -g --depth=0 &> /dev/null; then
    sudo -H npm i --silent -g "${package}"@latest --unsafe-perm
    ((result |= $?))
  fi

  monitor "${TASK_PRINT}" "${package}" "${result}"

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

  monitor "${TASK_PRINT}" "${package}" "${result}"

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

  monitor "${TASK_PRINT}" "${package}" "${result}"

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

  monitor "${TASK_PRINT}" "${file}" "${result}"

  return "${result}"
}

function initialize_resources() {
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

for package in "${APT_PACKAGES[@]}"; do
  install_apt_dependency "${package}"
  ((retval |= $?))
done

# Install pip dependencies

for package in "${PIP_PACKAGES[@]}"; do
  install_pip_dependency "${package}"
  ((retval |= $?))
done

# Install npm dependencies

for package in "${NPM_PACKAGES[@]}"; do
  install_npm_dependency "${package}"
  ((retval |= $?))
done

create_hook pre-commit "npm test"
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

initialize_resources

exit "${retval}"
