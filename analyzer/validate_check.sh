#!/bin/bash
#
# Perform analysis of the codebase.

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
    *) "[error] Unexpected option: ${flag}" ;;
  esac
done
readonly L_FLAG

# Control flow logic

cd "${PATH_SCRIPTDIR}"/check || exit

declare -i result=0
declare -i retval=0

# Run alex check
if true; then
  chmod +x run_alex.sh
  ./run_alex.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Check - ${L_FLAG}] passed alex"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Check - ${L_FLAG}] skipped alex"
  else
    ((retval |= 1))
    printer "🟠 [Check - ${L_FLAG}] failed alex"
  fi
else
  printer "🟡 [Check - ${L_FLAG}] disabled alex"
fi

# Run codespell check
if true; then
  chmod +x run_codespell.sh
  ./run_codespell.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Check - ${L_FLAG}] passed codespell"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Check - ${L_FLAG}] skipped codespell"
  else
    ((retval |= 1))
    printer "🟠 [Check - ${L_FLAG}] failed codespell"
  fi
else
  printer "🟡 [Check - ${L_FLAG}] disabled codespell"
fi

# Run mdspell check
if true; then
  chmod +x run_mdspell.sh
  ./run_mdspell.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Check - ${L_FLAG}] passed mdspell"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Check - ${L_FLAG}] skipped mdspell"
  else
    ((retval |= 1))
    printer "🟠 [Check - ${L_FLAG}] failed mdspell"
  fi
else
  printer "🟡 [Check - ${L_FLAG}] disabled mdspell"
fi

# Run markdown-link check
if false; then
  chmod +x run_markdown_link_check.sh
  ./run_markdown_link_check.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Check - ${L_FLAG}] passed markdown-link-check"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Check - ${L_FLAG}] skipped markdown-link-check"
  else
    ((retval |= 1))
    printer "🟠 [Check - ${L_FLAG}] failed markdown-link-check"
  fi
else
  # TODO(AK) Detects alive links as broken
  printer "🟡 [Check - ${L_FLAG}] disabled markdown-link-check"
fi

# Return value
exit "${retval}"
