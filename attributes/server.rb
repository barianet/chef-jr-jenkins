#
# Cookbook Name:: jr-jenkins
# Attributes:: server
#

# Pin to 1.555-1.1 to fix this issue:
# https://github.com/opscode-cookbooks/jenkins/issues/171
default['jenkins']['master']['install_method'] = 'package'
default['jenkins']['master']['version'] = '1.555-1.1'

# Jenkins master overrides
default['jenkins']['master']['jvm_options'] = '-Dorg.apache.commons.jelly.tags.fmt.timeZone=America/New_York'
