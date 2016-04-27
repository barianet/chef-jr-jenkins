#
# Cookbook Name:: jr-jenkins
# Attributes:: default
#

# Don't change this default. This will be overridden in node.normal once the
# security scheme has been applied.
default['jr-jenkins']['security_enabled'] = false

# Specify the name of the default admin user in Jenkins.
default['jr-jenkins']['user']['name'] = 'admin'

# Specify install method and version of Jenkins.
default['jenkins']['master']['install_method'] = 'package'
default['jenkins']['master']['version'] = '1.652-1.1'
default['jenkins']['master']['repository'] = 'http://jr-repo-01.s3-website-us-east-1.amazonaws.com/redhat/noarch'

# Jenkins master overrides
default['jenkins']['master']['jvm_options'] = '-Dorg.apache.commons.jelly.tags.fmt.timeZone=America/New_York'
default['jenkins']['master']['listen_address'] = '127.0.0.1'

# We need Java 7 for Jenkins
default['java']['jdk_version'] = '7'
default['jenkins']['java'] = '/usr/bin/java'

# Jenkins plugins
default['jr-jenkins']['plugins'] = %w(
  greenballs
  mailer
)

# Jenkins proxy defaults
default['jr-jenkins']['proxy']['server_name'] = node['fqdn']
default['jr-jenkins']['proxy']['server_ip'] = node['apache']['listen_addresses'].first
default['jr-jenkins']['proxy']['server_port'] = node['apache']['listen_ports'].first
default['jr-jenkins']['proxy']['server_ip_ssl'] = node['apache']['listen_addresses'].first
default['jr-jenkins']['proxy']['server_port_ssl'] = '443'
default['jr-jenkins']['proxy']['ssl_certificate'] = nil
default['jr-jenkins']['proxy']['basic_auth_user'] = nil
default['jr-jenkins']['proxy']['basic_auth_pass'] = nil
default['jr-jenkins']['proxy']['basic_auth_allow_from'] = %w()
default['jr-jenkins']['proxy']['sslprotocol'] = ' -All +TLSv1.2'
default['jr-jenkins']['proxy']['sslciphersuite'] = 'ECDHE-RSA-AES128-SHA256:AES128-GCM-SHA256:RC4:HIGH:!MD5:!aNULL:!EDH'
