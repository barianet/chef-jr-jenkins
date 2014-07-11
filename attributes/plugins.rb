#
# Cookbook Name:: jr-jenkins
# Attributes:: plugins
#

# Jenkins plugins
default['jr-jenkins']['plugins'] = %w[
  git
  git-client
  github
  github-api
  greenballs
  mailer
  scm-api
  ssh-credentials
  ws-cleanup
]
