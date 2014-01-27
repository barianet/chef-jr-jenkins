#
# Cookbook Name:: jr-jenkins
# Attributes:: server
#

# Jenkins master overrides
default['jenkins']['master']['jvm_options'] = "-Dorg.apache.commons.jelly.tags.fmt.timeZone=America/New_York"
