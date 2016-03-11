#
# Cookbook Name:: jr-jenkins
# Attributes:: server
#

# Pin to 1.555-1.1 to fix this issue:
# https://github.com/opscode-cookbooks/jenkins/issues/171
default['jenkins']['master']['install_method'] = 'package'
default['jenkins']['master']['version'] = '1.652-1.1'
# Point to the Jackson River Jenkins CI Repo Mirror on S3
default['jenkins']['master']['repository'] = 'http://jr-repo-01.s3-website-us-east-1.amazonaws.com/redhat/noarch'

# Jenkins master overrides
default['jenkins']['master']['jvm_options'] = '-Dorg.apache.commons.jelly.tags.fmt.timeZone=America/New_York'

# We need Java 7 for new Jenkins
default['java']['jdk_version'] = '7'
