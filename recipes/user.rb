#
# Cookbook Name:: jr-jenkins
# Recipe:: user
#
# Copyright (C) 2013 Jackson River
#
# All rights reserved - Do Not Redistribute
#

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

ssh_path = File.join(node['jenkins']['master']['home'], '.ssh')

# Create a public/private key pair.
unless node['jr-jenkins']['user']['private_key']
  require 'net/ssh'
  key = OpenSSL::PKey::RSA.new(4096)
  node.set['jr-jenkins']['user']['private_key'] = key.to_pem
  node.set['jr-jenkins']['user']['public_key'] = "#{key.ssh_type} #{[key.to_blob].pack('m0')}"
end

# Set the private key on the Jenkins executor. Do this here so the private
# key is available to the executor for the following jobs. Otherwise, we want
# to set this after we enable authentication.
if node['jenkins']['executor']['private_key'].nil? && File.exists?(File.join(ssh_path, "jenkins_user__#{node['jr-jenkins']['user']['name']}"))
  log ("setting jenkins][executor][private_key") { level :debug }
  node.set['jenkins']['executor']['private_key'] = node['jr-jenkins']['user']['private_key']
end

# Generate a password.
unless node['jr-jenkins']['user']['passphrase']
  node.set['jr-jenkins']['user']['passphrase'] = secure_password
end

# Create the Jenkins user with the public key.
jenkins_user node['jr-jenkins']['user']['name'] do
  public_keys node['jr-jenkins']['user']['public_key']
end

jenkins_private_key_credentials node['jr-jenkins']['user']['name'] do
  private_key node['jr-jenkins']['user']['private_key']
  passphrase node['jr-jenkins']['user']['passphrase']
end

# Enable authentication.
jenkins_script 'add_authentication' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*
    import hudson.security.*
    import org.jenkinsci.plugins.*

    def instance = Jenkins.getInstance()

    def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
    instance.setAuthorizationStrategy(strategy)

    instance.save()
  EOH
  action :nothing
end

# Set the private key on the Jenkins executor.
ruby_block "jenkins_executor_key" do
  block do
    node.set['jenkins']['executor']['private_key'] = node['jr-jenkins']['user']['private_key']
  end
  action :nothing
end

# Ensure the ssh_path.
directory ssh_path do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode "0700"
  recursive false
end

# Write the public key file.
file File.join(ssh_path, "jenkins_user__#{node['jr-jenkins']['user']['name']}.pub") do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode "0600"
  content node['jr-jenkins']['user']['public_key']
end

# Write the private key file.
file File.join(ssh_path, "jenkins_user__#{node['jr-jenkins']['user']['name']}") do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode "0600"
  content node['jr-jenkins']['user']['private_key']
  notifies :create, "ruby_block[jenkins_executor_key]", :delayed
  notifies :execute, "jenkins_script[add_authentication]", :delayed
end
