#
# Cookbook Name:: jr-jenkins
# Recipe:: user
#
# Copyright (c) 2016 Jackson River, All Rights Reserved.

require 'openssl'
require 'net/ssh'

# Get public/private keypair for the admin user from the data bag.
admin_user = data_bag_item('jr-jenkins-users', node['jr-jenkins']['user']['name'])
key = OpenSSL::PKey::RSA.new(admin_user['private_key'])
admin_user_private_key = key.to_pem
admin_user_public_key = "#{key.ssh_type} #{[key.to_blob].pack('m0')}"

# If security was enabled in a previous run, then set the private key in the
# run_state as required by the Jenkins cookbook.
ruby_block 'set jenkins private key' do
  block do
    node.run_state[:jenkins_private_key] = admin_user_private_key # ~FC001
  end
  only_if { node['jr-jenkins']['security_enabled'] }
end

# Ensure the admin user. Notify the resource to configure the permissions for
# the admin user.
jenkins_user node['jr-jenkins']['user']['name'] do
  password admin_user['password']
  public_keys [admin_user_public_key]
  not_if { node['jr-jenkins']['security_enabled'] }
  notifies :execute, 'jenkins_script[configure permissions]', :immediately
end

# Configure the permissions so that login is required and the admin user is an
# administrator. After this point the private key will be required to execute
# jenkins scripts (including querying if users exist) so we notify the `set the
# security_enabled flag` resource to set this up.
jenkins_script 'configure permissions' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*
    import hudson.security.*

    def instance = Jenkins.getInstance()

    def hudsonRealm = new HudsonPrivateSecurityRealm(false)
    instance.setSecurityRealm(hudsonRealm)

    def strategy = new GlobalMatrixAuthorizationStrategy()
    strategy.add(Jenkins.ADMINISTER, "#{node['jr-jenkins']['user']['name']}")
    instance.setAuthorizationStrategy(strategy)

    instance.save()
  EOH
  notifies :create, 'ruby_block[set the security_enabled flag]', :immediately
  action :nothing
end

# Set the security_enabled flag and set the run_state to use the private key.
ruby_block 'set the security_enabled flag' do
  block do
    node.run_state[:jenkins_private_key] = admin_user_private_key # ~FC001
    node.set['jr-jenkins']['security_enabled'] = true
    node.save
  end
  action :nothing
end
