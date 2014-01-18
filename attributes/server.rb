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

# Apache overrides
default['apache']['timeout'] = 30
default['apache']['keepalive'] = 'Off'
default['apache']['servertokens'] = 'Prod'
default['apache']['serversignature'] = 'Off'
default['apache']['traceenable'] = 'Off'
default['apache']['prefork']['startservers'] = 4
default['apache']['prefork']['minspareservers'] = 1
default['apache']['prefork']['maxspareservers'] = 4
default['apache']['prefork']['serverlimit'] = 10
default['apache']['prefork']['maxclients'] = 10
default['apache']['prefork']['maxrequestsperchild'] = 10_000

# Jenkins master overrides
default['jenkins']['master']['jvm_options'] = "-Dorg.apache.commons.jelly.tags.fmt.timeZone=America/New_York"
