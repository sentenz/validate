#!/bin/bash
#
# Perform lint of the codebase.

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

cd "${PATH_SCRIPTDIR}"/lint || exit

declare -i result=0
declare -i retval=0

# Run golangci-lint
file="go.mod"
if is_file "${PATH_TOPLEVEL}""/""${file}"; then
  chmod +x run_golangci_lint.sh
  ./run_golangci_lint.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Lint - ${L_FLAG}] passed golangci-lint"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Lint - ${L_FLAG}] skipped golangci-lint"
  else
    ((retval |= 1))
    printer "🟠 [Lint - ${L_FLAG}] failed golangci-lint"
  fi
else
  printer "🟡 [Lint - ${L_FLAG}] disabled golangci-lint"
fi

# Run C/C++ lint
if true; then
  chmod +x run_clang_tidy.sh
  ./run_clang_tidy.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Lint - ${L_FLAG}] passed clang-tidy"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Lint - ${L_FLAG}] skipped clang-tidy"
  else
    ((retval |= 1))
    printer "🟠 [Lint - ${L_FLAG}] failed clang-tidy"
  fi
else
  printer "🟡 [Lint - ${L_FLAG}] disabled clang-tidy"
fi

# Run C/C++ lint (Google Style Code)
if true; then
  chmod +x run_cpplint.sh
  ./run_cpplint.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Lint - ${L_FLAG}] passed cpplint"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Lint - ${L_FLAG}] skipped cpplint"
  else
    ((retval |= 1))
    printer "🟠 [Lint - ${L_FLAG}] failed cpplint"
  fi
else
  printer "🟡 [Lint - ${L_FLAG}] disabled cpplint"
fi

# Run C/C+ checks
if true; then
  chmod +x run_cppcheck.sh
  ./run_cppcheck.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Lint - ${L_FLAG}] passed cppcheck"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Lint - ${L_FLAG}] skipped cppcheck"
  else
    ((retval |= 1))
    printer "🟠 [Lint - ${L_FLAG}] failed cppcheck"
  fi
else
  printer "🟡 [Lint - ${L_FLAG}] disabled cppcheck"
fi

# Run shell/bash lint
if true; then
  chmod +x run_shellcheck.sh
  ./run_shellcheck.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Lint - ${L_FLAG}] passed shellcheck"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Lint - ${L_FLAG}] skipped shellcheck"
  else
    ((retval |= 1))
    printer "🟠 [Lint - ${L_FLAG}] failed shellcheck"
  fi
else
  printer "🟡 [Lint - ${L_FLAG}] disabled shellcheck"
fi

# Run git commit lint
if true; then
  chmod +x run_commitlint.sh
  ./run_commitlint.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Lint - ${L_FLAG}] passed commitlint"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Lint - ${L_FLAG}] skipped commitlint"
  else
    ((retval |= 1))
    printer "🟠 [Lint - ${L_FLAG}] failed commitlint"
  fi
else
  printer "🟡 [Lint - ${L_FLAG}] disabled commitlint"
fi

# Run yaml lint
if true; then
  chmod +x run_yamllint.sh
  ./run_yamllint.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Lint - ${L_FLAG}] passed yamllint"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Lint - ${L_FLAG}] skipped yamllint"
  else
    ((retval |= 1))
    printer "🟠 [Lint - ${L_FLAG}] failed yamllint"
  fi
else
  printer "🟡 [Lint - ${L_FLAG}] disabled yamllint"
fi

# Run json lint
if false; then
  chmod +x run_jsonlint.sh
  ./run_jsonlint.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Lint - ${L_FLAG}] passed jsonlint"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Lint - ${L_FLAG}] skipped jsonlint"
  else
    ((retval |= 1))
    printer "🟠 [Lint - ${L_FLAG}] failed jsonlint"
  fi
else
  # TODO(AK) No option to add an empty line at the end of the string
  printer "🟡 [Lint - ${L_FLAG}] disabled jsonlint"
fi

# Run markdown lint
if true; then
  chmod +x run_markdownlint.sh
  ./run_markdownlint.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Lint - ${L_FLAG}] passed markdownlint"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Lint - ${L_FLAG}] skipped markdownlint"
  else
    ((retval |= 1))
    printer "🟠 [Lint - ${L_FLAG}] failed markdownlint"
  fi
else
  printer "🟡 [Lint - ${L_FLAG}] disabled markdownlint"
fi

# Run remark lint
if true; then
  chmod +x run_remark.sh
  ./run_remark.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Lint - ${L_FLAG}] passed remark"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Lint - ${L_FLAG}] skipped remark"
  else
    ((retval |= 1))
    printer "🟠 [Lint - ${L_FLAG}] failed remark"
  fi
else
  printer "🟡 [Lint - ${L_FLAG}] disabled remark"
fi

# Run docker lint
if true; then
  chmod +x run_dockerfilelint.sh
  ./run_dockerfilelint.sh -l "${L_FLAG}"
  ((result = $?))

  if ((result == 0)); then
    ((retval |= 0))
    printer "🟢 [Lint - ${L_FLAG}] passed dockerfilelint"
  elif ((result == 255)); then
    ((retval |= 0))
    printer "⚪ [Lint - ${L_FLAG}] skipped dockerfilelint"
  else
    ((retval |= 1))
    printer "🟠 [Lint - ${L_FLAG}] failed dockerfilelint"
  fi
else
  printer "🟡 [Lint - ${L_FLAG}] disabled dockerfilelint"
fi

# Return value
exit "${retval}"
