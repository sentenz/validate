#!/bin/bash
#
# Perform requirements installation.

# -x: print a trace (debug)
# -u: treat unset variables
# -o pipefail: return value of a pipeline
# -o posix: match the standard
set -uo pipefail

# Constant variables

PATH_TOPLEVEL="$(git rev-parse --show-superproject-working-tree --show-toplevel | head -1)"
readonly PATH_TOPLEVEL
readonly TASK_PRINT="Validate - requirement"
readonly -a APT_PACKAGES=(
  build-essential
  git
  automake
  python3.8
  python-is-python3
  python3-pip
  gcc-9
  snapd
  cmake
  apt-transport-https
  lsb-release
  ca-certificates
  curl
  dirmngr
  nodejs
)

# Internal functions

function printer() {
  echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

function monitor() {
  local task=$1
  local package=$2
  local status=$3

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

function install_apt_dependency() {
  local package=$1

  local -i result=0

  if ! command -v "${package}" &> /dev/null; then
    sudo apt install -y -qq "${package}"
    ((result = $?))
  fi

  monitor "${TASK_PRINT}" "${package}" "${result}"

  return "${result}"
}

# Control flow logic

cd "${PATH_TOPLEVEL}" || exit

declare -i retval=0

# Update apt requirements

sudo add-apt-repository -y ppa:git-core/ppa
((retval |= $?))

sudo apt update -y -qq && sudo apt upgrade -y -qq
((retval |= $?))

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
((retval |= $?))

# Install apt requirements

for package in "${APT_PACKAGES[@]}"; do
  install_apt_dependency "${package}"
  ((retval |= $?))
done

# Install go requirements

file="go.mod"
if is_file "${file}"; then
  if ! command -v go &> /dev/null; then
    wget https://dl.google.com/go/go1.17.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.17.linux-amd64.tar.gz && sudo rm -f go1.17.linux-amd64.tar.gz
    ((retval |= $?))
  fi
  export PATH=/usr/local/go/bin:"${PATH}"
fi

exit "${retval}"
