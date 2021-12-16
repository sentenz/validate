#!/bin/bash
#
# Perform setup.

# -x: print a trace (debug)
# -u: treat unset variables
# -o pipefail: return value of a pipeline
# -o posix: match the standard
set -uo pipefail

# Constant variables

PATH_SCRIPTDIR="$(dirname "$(realpath "$0")")"
readonly PATH_SCRIPTDIR

# Internal functions

function printer() {
  echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

function monitor() {
  local task=$1
  local analyzer=$2
  local status=$3

  if ((status == 0)); then
    printer "🟢 [${task}] succeeded ${analyzer}"
  else
    printer "🟠 [${task}] failed ${analyzer}"
  fi
}

# Control flow logic

cd "${PATH_SCRIPTDIR}" || exit

declare -i result=0
declare -i retval=0

# Run requirements installation
chmod +x setup_requirements.sh
./setup_requirements.sh

result=$?
((retval |= result))

monitor "Setup" "requirements" "${result}"

# Run analyzer installation
chmod +x setup_analyzer.sh
./setup_analyzer.sh

result=$?
((retval |= result))

monitor "Setup" "analyzer" "${result}"

if ((result == 1)); then
  exit "${retval}"
fi

# Return value
exit "${retval}"
