#!/usr/bin/env bats 

load test_helper

setup() {
  _setup
  stub cs "launch scala:latest.stable   -- -version : echo 'Scala code runner version 2.13.3 -- Copyright 2002-2020, LAMP/EPFL and Lightbend, Inc.'" 
}

teardown() {
  _teardown
  unstub cs
}

@test "scala -version" {
    expected="Scala code runner version 2.13.3 -- Copyright 2002-2020, LAMP/EPFL and Lightbend, Inc."
    actual="$(scala -version)"
    [ "$expected" == "$actual" ]
}