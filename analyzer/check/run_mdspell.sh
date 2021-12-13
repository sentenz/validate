#!/bin/bash
#
# Perform a check of the markdown spelling by running mdspell.

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
readonly FILE_CONF=".spelling"
readonly FILE_LOG="${PATH_SCRIPTDIR}""/mdspell.log"
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

PATH_CONFDIR="${PATH_SCRIPTDIR}"
if [[ -f "${PATH_RCDIR}"/"${FILE_CONF}" && "$(diff -q "${PATH_RCDIR}"/"${FILE_CONF}" "${PATH_SCRIPTDIR}"/"${FILE_CONF}")" ]]; then
  PATH_CONFDIR="${PATH_RCDIR}"
fi
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
  readonly SORT="sort < ${PATH_CONFDIR}/${FILE_CONF} | sort | uniq | tee ${FILE_CONF}.tmp > /dev/null && mv ${FILE_CONF}.tmp ${PATH_CONFDIR}/${FILE_CONF}"
  readonly CLI="mdspell -n -a -r -d --en-us --en-gb '!**/node_modules/**/*.md' '!**/vendor/**/*.md' '!**/.github/**/*.md' '!**/translations/**/*.md'"

  eval "${SORT}"

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
  ERRORS=$(grep -i -c -E 'spelling errors found' "${FILE_LOG}" || true)
  readonly ERRORS

  if [[ "${ERRORS}" -ne 0 ]]; then
    exit 1
  else
    rm -f "${FILE_LOG}"
  fi
fi
