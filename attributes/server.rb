#
# Cookbook Name:: jr-jenkins
# Attributes:: server
#

# Use the war installation method, pin to 1.555 to fix this issue:
# https://github.com/opscode-cookbooks/jenkins/issues/171
default['jenkins']['master']['install_method'] = 'war'
default['jenkins']['master']['version'] = '1.555'
default['jenkins']['master']['source'] = "#{node['jenkins']['master']['mirror']}/war/#{node['jenkins']['master']['version']}/jenkins.war"

# Jenkins master overrides
default['jenkins']['master']['jvm_options'] = "-Dorg.apache.commons.jelly.tags.fmt.timeZone=America/New_York"
