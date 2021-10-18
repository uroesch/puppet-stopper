# Simple rake file for testing

TEST_DIR = 'tests'

task :default => :test

task :test do
  sh "sudo bats #{TEST_DIR}/*bats"
end
