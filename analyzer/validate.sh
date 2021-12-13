#!/bin/bash
#
# Perform the validation of the codebase.

# -x: print a trace (debug)
# -u: treat unset variables
# -o pipefail: return value of a pipeline
# -o posix: match the standard
set -uo pipefail

# Constant variables

PATH_SCRIPTDIR="$(dirname "$(realpath "$0")")"
readonly PATH_SCRIPTDIR
readonly REGEX_PATH="."
readonly REGEX_CHECK="^.*\.(log)$"

# Options

L_FLAG="all"
while getopts 'l:' flag; do
  case "${flag}" in
    l) L_FLAG="${OPTARG}" ;;
    *) "[error] Unexpected option: ${flag}" ;;
  esac
done
readonly L_FLAG

# Control flow logic

cd "${PATH_SCRIPTDIR}" || exit

# Cleanup files from a previous run
find "${REGEX_PATH}" -type f -regextype posix-egrep -regex "${REGEX_CHECK}" -delete

declare -i retval=0

# Validate format
chmod +x validate_format.sh
./validate_format.sh -l "${L_FLAG}"
((retval |= $?))

# Validate legal
chmod +x validate_legal.sh
./validate_legal.sh -l "${L_FLAG}"
((retval |= $?))

# Validate lint
chmod +x validate_lint.sh
./validate_lint.sh -l "${L_FLAG}"
((retval |= $?))

# Validate check
chmod +x validate_check.sh
./validate_check.sh -l "${L_FLAG}"
((retval |= $?))

# Return value
exit "${retval}"
