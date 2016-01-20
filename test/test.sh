#!/bin/bash

realpath() {
  echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
}

SBT_EXEC=$(realpath $1)

run_test() {
  local DIR=$1
  local CMD=$2
  local EXPECTED=$3
  local IN=$4

  local OLD_PWD=$PWD
  cd $DIR

  if [ "$IN" == "" ]; then
    local OUTPUT=$($CMD)
  else
    local OUTPUT=$(echo $IN | $CMD)
  fi

  cd $OLD_PWD

  printf "Output:\n$OUTPUT\n\n"
  printf "Expected:\n$EXPECTED\n\n"

  if [ "${OUTPUT#*$EXPECTED}" != "$OUTPUT" ]; then
    printf "Test passed!\n\n"
  else
    printf "Test failed!\n\n"
    exit 1
  fi
}

run_test "with_default" "${SBT_EXEC}" "hello, world"

run_test "with_default" "${SBT_EXEC} shell" "> exit" "exit"

run_test "with_default" "${SBT_EXEC} foo" "Not a valid command: foo"

# run Mac tests
if [[ "$(uname)" == "Darwin" ]]; then
  # simulate a non-interactive open by running this from the home dir
  run_test "$HOME" "${SBT_EXEC}" "Not a valid command: default"
  run_test "$HOME" "${SBT_EXEC}" "Set current project to sbt-launcher-default"
fi