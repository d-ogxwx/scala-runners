#!/usr/bin/env bats

load test_helper

setup() {
  _setup
  stub cs "launch scalac:latest.stable   -- -version : echo 'Scala compiler version 2.13.2 -- Copyright 2002-2020, LAMP/EPFL and Lightbend, Inc.'" 
}

teardown() {
  _teardown
  unstub cs
}

@test "scalac -version" {
  expected="Scala compiler version 2.13.2 -- Copyright 2002-2020, LAMP/EPFL and Lightbend, Inc."
  actual="$(scalac -version)"
  [ "$expected" == "$actual" ]
}