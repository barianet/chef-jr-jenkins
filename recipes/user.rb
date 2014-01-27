#
# Cookbook Name:: jr-jenkins
# Recipe:: user
#
# Copyright (C) 2013 Jackson River
#
# All rights reserved - Do Not Redistribute
#

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

# Create a public/private key pair.
unless node['jr-jenkins']['user']['private_key']
  require 'net/ssh'
  key = OpenSSL::PKey::RSA.new(4096)
  node.set['jr-jenkins']['user']['private_key'] = key.to_pem
  node.set['jr-jenkins']['user']['public_key'] = "#{key.ssh_type} #{[key.to_blob].pack('m0')}"
end

# Set a password.
unless node['jr-jenkins']['user']['passphrase']
  node.set['jr-jenkins']['user']['passphrase'] = secure_password
end

# Create the Jenkins user with the public key.
jenkins_user node['jr-jenkins']['user']['name'] do
  passphrase node['jr-jenkins']['user']['passphrase']
  public_keys node['jr-jenkins']['user']['public_key']
end

# Set the private key on the Jenkins executor.
ruby_block 'set private key' do
  block { node.set['jenkins']['executor']['private_key'] = node['jr-jenkins']['user']['private_key'] }
end
