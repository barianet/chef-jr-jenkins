#
# Cookbook Name:: jr-jenkins
# Recipe:: server
#
# Copyright (C) 2013 Jackson River
#
# All rights reserved - Do Not Redistribute
#

# Install Java.
include_recipe "jenkins::java"

# Install Jenkins master.
include_recipe "jenkins::master"

# Install SSL certificate.
if node['jr-jenkins']['proxy']['ssl_certificate']
  include_recipe "ssl_certificates"
  ssl_certificate node['jr-jenkins']['proxy']['ssl_certificate']
end

# Ensure the htpasswd file is present.
if node['jr-jenkins']['proxy']['basic_auth_user']
  include_recipe "htpasswd"
  basic_auth_htpasswd = File.join(node['jenkins']['master']['home'], '.htpasswd')
  htpasswd basic_auth_htpasswd do
    user node['jr-jenkins']['proxy']['basic_auth_user']
    password node['jr-jenkins']['proxy']['basic_auth_password']
  end
end

# Ensure Apache is ready to proxy.
include_recipe "apache2"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"

# Define the web_app for the proxy.
web_app node['jr-jenkins']['proxy']['server_name'] do
  template 'jenkins-webapp.conf.erb'
  server_ip node['jr-jenkins']['proxy']['server_ip']
  server_port node['jr-jenkins']['proxy']['server_port']
  if node['jr-jenkins']['proxy']['ssl_certificate']
    server_ip_ssl node['jr-jenkins']['proxy']['server_ip_ssl']
    server_port_ssl node['jr-jenkins']['proxy']['server_port_ssl']
    ssl_cert_file "#{node[:ssl_certificates][:path]}/#{node['jr-jenkins']['proxy']['ssl_certificate']}.pem"
    ssl_key_file "#{node[:ssl_certificates][:private_path]}/#{node['jr-jenkins']['proxy']['ssl_certificate']}.key"
    ssl_chain_file "#{node[:ssl_certificates][:path]}/#{node['jr-jenkins']['proxy']['ssl_certificate']}.ca-bundle"
  end
  basic_auth_htpasswd basic_auth_htpasswd
end
