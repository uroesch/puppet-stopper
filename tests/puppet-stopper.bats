#!/usr/bin/env bats

load helpers

@test "puppet-stopper: Common option --help" {
  output=$(puppet-stopper --help 2>&1)
  [[ ${output} =~ ' -d, --days NUMBER ' ]]
  [[ ${output} =~ ' -e, --extend ' ]]
  [[ ${output} =~ ' -h, --help ' ]]
  [[ ${output} =~ ' -i, --info ' ]]
  [[ ${output} =~ ' -l, --lock COMMENT' ]]
  [[ ${output} =~ '     --statedir ' ]]
  [[ ${output} =~ ' -u, --unlock ' ]]
  [[ ${output} =~ ' -U, --unlock-expired ' ]]
  [[ ${output} =~ '     --validate  ' ]]
  [[ ${output} =~ ' -V, --version ' ]]
}

@test "puppet-stopper: Common option -h" {
  output=$(puppet-stopper -h 2>&1)
  [[ ${output} =~ ' -d, --days NUMBER ' ]]
  [[ ${output} =~ ' -e, --extend ' ]]
  [[ ${output} =~ ' -h, --help ' ]]
  [[ ${output} =~ ' -i, --info ' ]]
  [[ ${output} =~ ' -l, --lock COMMENT' ]]
  [[ ${output} =~ '     --statedir ' ]]
  [[ ${output} =~ ' -u, --unlock ' ]]
  [[ ${output} =~ ' -U, --unlock-expired ' ]]
  [[ ${output} =~ '     --validate  ' ]]
  [[ ${output} =~ ' -V, --version ' ]]
}

@test "puppet-stopper: Common option --version" {
  puppet-stopper --version | grep -w ${PUPPET_STOPPER_VERSION}
}

@test "puppet-stopper: Common option -V" {
  puppet-stopper -V | grep -w ${PUPPET_STOPPER_VERSION}
}

@test "puppet-stopper: Option --lock" {
  puppet-stopper --statedir ${PUPPET_STATE_DIR} --lock "${PUPPET_STOPPER_MESSAGE}"
  test -f ${BATS_TEST_DIRNAME}/state/agent_disabled.lock
  grep "${PUPPET_STOPPER_MESSAGE}" ${PUPPET_STOPPER_LOCK}
  grep "${PUPPET_STOPPER_DATE1}" ${PUPPET_STOPPER_LOCK}

}

@test "puppet-stopper: Option --extend --days 2" {
  puppet-stopper --statedir ${PUPPET_STATE_DIR} --extend --days 2
  test -f ${BATS_TEST_DIRNAME}/state/agent_disabled.lock
  grep "${PUPPET_STOPPER_MESSAGE}" ${PUPPET_STOPPER_LOCK}
  grep "${PUPPET_STOPPER_DATE2}" ${PUPPET_STOPPER_LOCK}
}

@test "puppet-stopper: Option --info [locked]" {
  puppet-stopper --statedir ${PUPPET_STATE_DIR} --info
  puppet-stopper --statedir ${PUPPET_STATE_DIR} --info |& \
    grep "Reason: ${PUPPET_STOPPER_MESSAGE}"
  puppet-stopper --statedir ${PUPPET_STATE_DIR} --info |& \
    grep "Time of unlock: ${PUPPET_STOPPER_DATE2}"
}

@test "puppet-stopper: Option --unlock" {
  puppet-stopper --statedir ${PUPPET_STATE_DIR} --unlock
  test ! -f ${BATS_TEST_DIRNAME}/state/agent_disabled.lock
}

@test "puppet-stopper: Option --info [unlocked]" {
  puppet-stopper --statedir ${PUPPET_STATE_DIR} --info |& \
    grep "puppet is not locked"
}
