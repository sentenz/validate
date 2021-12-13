#!/bin/bash
#
# Perform a dynamic analysis of the codebase by running valgirnd memcheck.

# -x: print a trace (debug)
# -u: treat unset variables
# -o pipefail: return value of a pipeline
# -o posix: match the standard
set -uo pipefail

PATH_BINARY="."

while getopts 'p:' flag; do
  case "${flag}" in
    p) PATH_BINARY="${OPTARG}" ;;
    *) "[error] Unexpected option: ${flag}" ;;
  esac
done

readonly PATH_BINARY
readonly FILE_LOG="${PATH_SCRIPTDIR}""/valgrind.log"

# Run valgrind
valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes --show-reachable=yes --error-limit=no -q --log-file="${FILE_LOG}" ./"${PATH_BINARY}"

# Analyze log
if [[ -f "${FILE_LOG}" ]]; then
  ERRORS=$(grep -c "ERROR SUMMARY" "${FILE_LOG}" || true)
  readonly ERRORS

  if [[ "${ERRORS}" -ne 0 ]]; then
    exit 1
  else
    rm -f "${FILE_LOG}"
  fi
fi
