TESTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BATS_MOCK_TMPDIR="${BATS_TMPDIR}"
BATS_MOCK_BINDIR="${BATS_MOCK_TMPDIR}/bin"
export PATH="$TESTDIR:$BATS_MOCK_BINDIR:$PATH"

stub() {
  local program="$1"
  local prefix="$(echo "$program" | tr a-z- A-Z_)"
  shift
  export "${prefix}_STUB_PLAN"="${BATS_MOCK_TMPDIR}/${program}-stub-plan"
  export "${prefix}_STUB_RUN"="${BATS_MOCK_TMPDIR}/${program}-stub-run"
  export "${prefix}_STUB_END"=
  mkdir -p "${BATS_MOCK_BINDIR}"
  ln -sf "${TESTDIR}/stub/bin" "${BATS_MOCK_BINDIR}/${program}"
  touch "${BATS_MOCK_TMPDIR}/${program}-stub-plan"
  for arg in "$@"; do printf "%s\n" "$arg" >> "${BATS_MOCK_TMPDIR}/${program}-stub-plan"; done
}

unstub() {
  local program="$1"
  local prefix="$(echo "$program" | tr a-z- A-Z_)"
  local path="${BATS_MOCK_BINDIR}/${program}"
  export "${prefix}_STUB_END"=1
  local STATUS=0
  "$path" || STATUS="$?"
  rm -f "$path" "${BATS_MOCK_TMPDIR}/${program}-stub-plan" "${BATS_MOCK_TMPDIR}/${program}-stub-run"
  return "$STATUS"
}

# default setup setting.
_setup() {
  ln -fs "$TESTDIR/../scala-runner" "$TESTDIR/scala-runner"
  ln -fs "$TESTDIR/../scala-runner" "$TESTDIR/scala"
  ln -fs "$TESTDIR/../scala-runner" "$TESTDIR/scalac"
}

# default teardown setting. 
_teardown() {
  unlink "$TESTDIR/scala-runner"
  unlink "$TESTDIR/scala"
  unlink "$TESTDIR/scalac"
}

setup () {
  _setup
}

teardown() {
  _teardown
}
