#!/bin/bash
#
# Perform a lint of the markdown files by running remark.

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
readonly PATH_RCDIR="${PATH_TOPLEVEL}"
readonly FILE_RC=".remarkrc.json"
readonly FILE_RC_IGNORE=".remarkignore"
readonly FILE_LOG="${PATH_SCRIPTDIR}""/remark.log"
readonly REGEX_PATTERNS="^(?!.*\/?!*(\.git|vendor|CHANGELOG.md)).*\.(md)$"

# Options

L_FLAG="all"
while getopts 'l:' flag; do
  case "${flag}" in
    l) L_FLAG="${OPTARG}" ;;
    *) "[error] Unexpected option: ${flag}" ;;
  esac
done
readonly L_FLAG

# Set resource path

readonly -a resources=(
  "${FILE_RC}"
  "${FILE_RC_IGNORE}"
)

PATH_CONFDIR="${PATH_SCRIPTDIR}"
for resource in "${resources[@]}"; do
  if [[ -f "${PATH_RCDIR}"/"${resource}" && "$(diff -q "${PATH_RCDIR}"/"${resource}" "${PATH_SCRIPTDIR}"/"${resource}")" ]]; then
    PATH_CONFDIR="${PATH_RCDIR}"
  fi
done
readonly PATH_CONFDIR

# Control flow logic

cd "${PATH_TOPLEVEL}" || exit

LIST=""
if [[ "${L_FLAG}" == "ci" ]]; then
  LIST=$(git diff --submodule=diff --diff-filter=d --name-only --line-prefix="${PATH_TOPLEVEL}/" remotes/origin/main... | grep -P "${REGEX_PATTERNS}" | xargs)
elif [[ "${L_FLAG}" == "diff" ]]; then
  LIST=$(git diff --submodule=diff --diff-filter=d --name-only --line-prefix="${PATH_TOPLEVEL}/" remotes/origin/HEAD... | grep -P "${REGEX_PATTERNS}" | xargs)
elif [[ "${L_FLAG}" == "staged" ]]; then
  LIST=$(git diff --submodule=diff --diff-filter=d --name-only --line-prefix="${PATH_TOPLEVEL}/" --cached | grep -P "${REGEX_PATTERNS}" | xargs)
elif [[ "${L_FLAG}" == "repo" ]]; then
  LIST=$(git ls-tree --full-tree -r --name-only HEAD | grep -P "${REGEX_PATTERNS}" | xargs -r printf -- "${PATH_TOPLEVEL}/%s ")
elif [[ "${L_FLAG}" == "all" ]]; then
  LIST=$(git ls-files --recurse-submodules | grep -P "${REGEX_PATTERNS}" | xargs -r printf -- "${PATH_TOPLEVEL}/%s ")
else
  echo "[error] Unexpected option: ${L_FLAG}" &> "${FILE_LOG}"
  exit 2
fi
readonly LIST

# Run analyzer
if [[ -n "${LIST}" ]]; then
  readonly CLI="remark --no-stdout --no-color --silent"

  (
    cd "${PATH_CONFDIR}" || exit

    for line in ${LIST}; do
      eval "${CLI}" "${line}"
    done
  ) &> "${FILE_LOG}"
else
  exit 255
fi

# Analyze log
if [[ -f "${FILE_LOG}" ]]; then
  ERRORS=$(grep -i -c -E 'error' "${FILE_LOG}" || true)
  readonly ERRORS
  WARNINGS=$(grep -i -c -E 'warning' "${FILE_LOG}" || true)
  readonly WARNINGS

  if [[ "${ERRORS}" -ne 0 || "${WARNINGS}" -ne 0 ]]; then
    exit 1
  else
    rm -f "${FILE_LOG}"
  fi
fi
