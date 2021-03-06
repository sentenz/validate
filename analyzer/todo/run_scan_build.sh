#!/bin/bash
#
# Perform C/C++ analysis of the codebase by running scan-build.

# -x: print a trace (debug)
# -u: treat unset variables
# -o pipefail: return value of a pipeline
# -o posix: match the standard
set -uo pipefail

readonly CC="gcc"
readonly CXX="g++"
readonly REPORT_DIR="."
SCAN_BUILD_ARGS="--use-analyzer=$(command -v $CC) --use-c++=$(command -v $CXX) --use-cc=$(command -v $CC) -o ${REPORT_DIR}"
PATH_TO_BUILDDIR="."
FILE_LOG="scan-build.log"

while getopts 'p:' flag; do
  case "${flag}" in
    p) PATH_TO_BUILDDIR="${OPTARG}" ;;
    *) "[error] Unexpected option: ${flag}" ;;
  esac
done

readonly PATH_TO_BUILDDIR
readonly SCAN_BUILD_ARGS
readonly FILE_LOG

# TODO(AK)
# Can't use ccache with clang analyzer - see
# https://llvm.org/bugs/show_bug.cgi?id=25851
#CMAKE_ARGS=${CPPCHECK_ARGS:="-DCOUCHBASE_DISABLE_CCACHE=1"}
# Build the project, therefore run cmake to generate all the makefiles,
# then just run make in the specific sub-directory.
#scan-build "$SCAN_BUILD_ARGS" cmake .. "$CMAKE_ARGS"

# Run scan-build tool
scan-build "$SCAN_BUILD_ARGS" make -C "${PATH_TO_BUILDDIR}" &> "${FILE_LOG}"

# Analyze log
if [[ -f "${FILE_LOG}" ]]; then
  ERRORS=$(grep -c "error" "${FILE_LOG}" || true)
  readonly ERRORS
  WARNINGS=$(grep -c "warning" "${FILE_LOG}" || true)
  readonly WARNINGS

  if [[ "${ERRORS}" -ne 0 || "${WARNINGS}" -ne 0 ]]; then
    exit 1
  else
    rm -f "${FILE_LOG}"
  fi
fi
