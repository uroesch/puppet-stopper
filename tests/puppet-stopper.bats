#!/usr/bin/env bats

load helpers

@test "puppet-stopper: Common option --help" {
  puppet-stopper --help |& grep -- "--lock COMMENT"
  puppet-stopper --help |& grep -- "--unlock"
  puppet-stopper --help |& grep -- "--extend"
  puppet-stopper --help |& grep -- "--days NUMBER"
  puppet-stopper --help |& grep -- "--info"
  puppet-stopper --help |& grep -- "--version"
  puppet-stopper --help |& grep -- "--statedir"
  puppet-stopper --help |& grep -- "--validate"
  puppet-stopper --help |& grep -- "--help"
}

@test "puppet-stopper: Common option -h" {
  puppet-stopper -h |& grep -- "--lock COMMENT"
  puppet-stopper -h |& grep -- "--unlock"
  puppet-stopper -h |& grep -- "--extend"
  puppet-stopper -h |& grep -- "--days NUMBER"
  puppet-stopper -h |& grep -- "--info"
  puppet-stopper -h |& grep -- "--version"
  puppet-stopper -h |& grep -- "--statedir"
  puppet-stopper -h |& grep -- "--validate"
  puppet-stopper -h |& grep -- "--help"
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
