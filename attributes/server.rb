#
# Cookbook Name:: jr-jenkins
# Attributes:: server
#

# Jenkins proxy defaults
default['jr-jenkins']['proxy']['server_name'] = node['fqdn']
default['jr-jenkins']['proxy']['server_ip'] = node['apache']['listen_addresses'].first
default['jr-jenkins']['proxy']['server_port'] = node['apache']['listen_ports'].first
default['jr-jenkins']['proxy']['server_ip_ssl'] = node['apache']['listen_addresses'].first
default['jr-jenkins']['proxy']['server_port_ssl'] = '443'
default['jr-jenkins']['proxy']['ssl_certificate'] = nil
default['jr-jenkins']['proxy']['basic_auth_user'] = nil
default['jr-jenkins']['proxy']['basic_auth_pass'] = nil

# Jenkins master overrides
default['jenkins']['master']['jvm_options'] = "-Dorg.apache.commons.jelly.tags.fmt.timeZone=America/New_York"

# Jenkins plugins
default['jr-jenkins']['plugins'] = %w[
  git
  git-client
  github
  github-api
  mailer
]
