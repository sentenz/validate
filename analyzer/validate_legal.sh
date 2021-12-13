#!/bin/bash
#
# Perform a legal review of the codebase.

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

# Options

L_FLAG="all"
while getopts 'l:' flag; do
  case "${flag}" in
    l) L_FLAG="${OPTARG}" ;;
    *) "default" ;;
  esac
done
readonly L_FLAG

# Control flow logic

cd "${PATH_SCRIPTDIR}"/legal || exit

declare -i result=0
declare -i retval=0

# Run license check
if true; then
  chmod +x run_licensecheck.sh
  ./run_licensecheck.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Legal - ${L_FLAG}] passed licensecheck"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Legal - ${L_FLAG}] skipped licensecheck"
  else
    ((retval |= 1))
    printer "🟠 [Legal - ${L_FLAG}] failed licensecheck"
  fi
else
  printer "🟡 [Legal - ${L_FLAG}] disabled licensecheck"
fi

# Return value
exit "${retval}"
