#!/bin/bash
#
# Perform formatting of the codebase.

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

# Internal functions

function printer() {
  echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

function is_file() {
  if [[ -f "$1" ]]; then
    return 0
  fi

  return 1
}

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

cd "${PATH_SCRIPTDIR}"/format || exit

declare -i result=0
declare -i retval=0

# Run go formatter
file="go.mod"
if is_file "${PATH_TOPLEVEL}""/""${file}"; then
  chmod +x run_gofmt.sh
  ./run_gofmt.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Format - ${L_FLAG}] passed gofmt"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Format - ${L_FLAG}] skipped gofmt"
  else
    ((retval |= 1))
    printer "🟠 [Format - ${L_FLAG}] failed gofmt"
  fi
else
  printer "🟡 [Format - ${L_FLAG}] disabled gofmt"
fi

# Run c/c++ formatter
if true; then
  chmod +x run_clang_format.sh
  ./run_clang_format.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Format - ${L_FLAG}] passed clang-format"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Format - ${L_FLAG}] skipped clang-format"
  else
    ((retval |= 1))
    printer "🟠 [Format - ${L_FLAG}] failed clang-format"
  fi
else
  printer "🟡 [Format - ${L_FLAG}] disabled clang-format"
fi

# Run shell/bash formatter
if true; then
  chmod +x run_shfmt.sh
  ./run_shfmt.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Format - ${L_FLAG}] passed shfmt"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Format - ${L_FLAG}] skipped shfmt"
  else
    ((retval |= 1))
    printer "🟠 [Format - ${L_FLAG}] failed shfmt"
  fi
else
  printer "🟡 [Format - ${L_FLAG}] disabled shfmt"
fi

# Run prettier formatter
if true; then
  chmod +x run_prettier.sh
  ./run_prettier.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Format - ${L_FLAG}] passed prettier"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Format - ${L_FLAG}] skipped prettier"
  else
    ((retval |= 1))
    printer "🟠 [Format - ${L_FLAG}] failed prettier"
  fi
else
  printer "🟡 [Format - ${L_FLAG}] disabled prettier"
fi

# Return value
exit "${retval}"
