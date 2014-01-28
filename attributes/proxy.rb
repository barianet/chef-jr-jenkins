#
# Cookbook Name:: jr-jenkins
# Attributes:: proxy
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
# Allow from github.com (for github webhook)
default['jr-jenkins']['proxy']['basic_auth_allow_from'] = [ '192.30.252' ]
