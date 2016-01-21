#!/bin/bash

realpath() {
  echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
}

SBT_EXEC=$(realpath $1)

run_test() {
  local DIR=$1
  local CMD=$2
  local ARGS=$3
  local EXPECTED=$4
  local IN=$5

  local OLD_PWD=$PWD
  cd $DIR

  if [ "$IN" != "" ]; then
    printf "STDIN: $IN\n"
  fi

  if [ "$ARGS" == "" ]; then
    if [ "$IN" == "" ]; then
      local OUTPUT=$($CMD)
    else
      local OUTPUT=$(echo $IN | $CMD)
    fi
  else
    printf "ARGS: $ARGS\n\n"
    if [ "$IN" == "" ]; then
      $CMD $ARGS > output.txt
    else
      echo $IN | $CMD $ARGS > output.txt
    fi
    local OUTPUT=$(cat output.txt)
    rm output.txt
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

run_test "with_default" "${SBT_EXEC}" "" "hello, world"

if [[ "$(uname)" != MSYS_NT* ]]; then
  # stdin doesn't seem to work as expected on windows / cygwin
  run_test "with_default" "${SBT_EXEC}" "shell" "> exit" "exit"
fi

run_test "with_default" "${SBT_EXEC}" "foo" "Not a valid command: foo"

# run Mac tests
if [[ "$(uname)" == "Darwin" ]]; then
  # simulate a non-interactive open by running this from the home dir
  run_test "$HOME" "${SBT_EXEC}" "" "Not a valid command: default"
  run_test "$HOME" "${SBT_EXEC}" "" "Set current project to sbt-launcher-default"
fi