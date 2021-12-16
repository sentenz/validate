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
readonly TASK="Validate - requirement"

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

  monitor "${TASK}" "${package}" "${result}"

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

# Install apt requirements

install_apt_dependency build-essential
((retval |= $?))

install_apt_dependency git
((retval |= $?))

install_apt_dependency automake
((retval |= $?))

install_apt_dependency python3.8
((retval |= $?))

install_apt_dependency python-is-python3
((retval |= $?))

install_apt_dependency python3-pip
((retval |= $?))

install_apt_dependency gcc-9
((retval |= $?))

install_apt_dependency snapd
((retval |= $?))

install_apt_dependency cmake
((retval |= $?))

install_apt_dependency apt-transport-https
((retval |= $?))

install_apt_dependency lsb-release
((retval |= $?))

install_apt_dependency ca-certificates
((retval |= $?))

install_apt_dependency curl
((retval |= $?))

install_apt_dependency dirmngr
((retval |= $?))

# TODO(AK) command -v npm still valid even node is uninstalled
if command -v node &> /dev/null && ! command -v npm &> /dev/null; then
  sudo apt remove nodejs
  ((retval |= $?))
  curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  sudo apt install -y -qq nodejs
  ((retval |= $?))
elif ! command -v node &> /dev/null; then
  curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  sudo apt install -y -qq nodejs
  ((retval |= $?))
fi
monitor "${TASK}" "nodejs" "${retval}"

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
