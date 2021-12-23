#!/bin/bash
#
# Perform a conventional-changelog check of the commit messages by running commitlint.

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
readonly FILE_RC=".commitlintrc.js"
readonly FILE_LOG="${PATH_SCRIPTDIR}""/commitlint.log"

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
  LIST=$(commitlint --from "$(git rev-parse --abbrev-ref remotes/origin/main)" --to "$(git rev-parse --abbrev-ref HEAD)" --config "${PATH_CONFDIR}"/"${FILE_RC}")
elif [[ "${L_FLAG}" == "diff" || "${L_FLAG}" == "repo" ]]; then
  LIST=$(commitlint --from "$(git rev-parse --abbrev-ref remotes/origin/HEAD)" --to "$(git rev-parse --abbrev-ref HEAD)" --config "${PATH_CONFDIR}"/"${FILE_RC}")
elif [[ "${L_FLAG}" == "staged" ]]; then
  # TODO(AK) currently husky commit-msg and run_commitlint.sh do not work together
  #EDITMSG_FILE=$(git rev-parse --git-path COMMIT_EDITMSG)
  #if [[ -z "${EDITMSG_FILE}" ]]; then
  #  exit 255
  #fi
  #LIST=$(commitlint --edit --config "${PATH_CONFDIR}"/"${FILE_RC}")
  exit 255
elif [[ "${L_FLAG}" == "all" ]]; then
  LIST=$(commitlint --to "$(git rev-parse --short HEAD)" --config "${PATH_CONFDIR}"/"${FILE_RC}")
else
  echo "[error] Unexpected option: ${L_FLAG}" &> "${FILE_LOG}"
  exit 2
fi
readonly LIST

# Run analyzer
if [[ -n "${LIST}" ]]; then
  echo "${LIST}" &> "${FILE_LOG}"
else
  exit 255
fi

# Analyze log
if [[ -f "${FILE_LOG}" ]]; then
  PROBLEMS=$(grep -i -c -E '[1-9]{1,} problems' "${FILE_LOG}" || true)
  readonly PROBLEMS
  WARNINGS=$(grep -i -c -E '[1-9]{1,} warnings' "${FILE_LOG}" || true)
  readonly WARNINGS

  if [[ "${PROBLEMS}" -ne 0 || "${WARNINGS}" -ne 0 ]]; then
    exit 1
  else
    rm -f "${FILE_LOG}"
  fi
fi
