# include helpers for bats tests

# -----------------------------------------------------------------------------
# Globals
# -----------------------------------------------------------------------------
export PATH=${BATS_TEST_DIRNAME}/../bin:${PATH}
export PATH=${BATS_TEST_DIRNAME}/helpers:${PATH}
export PUPPET_STATE_DIR=${BATS_TEST_DIRNAME}/state
export PUPPET_STOPPER_LOCK=${PUPPET_STATE_DIR}/agent_disabled.lock
export PUPPET_STOPPER_VERSION="2023-07-02"
export PUPPET_STOPPER_MESSAGE="Test Lock Message"
export PUPPET_STOPPER_DATE1=$(date -d "1 day" +"%F")
export PUPPET_STOPPER_DATE2=$(date -d "2 days" +"%F")
