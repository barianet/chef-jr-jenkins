#
# Cookbook Name:: jr-jenkins
# Recipe:: plugins
#
# Copyright (c) 2016 Jackson River, All Rights Reserved.

# Install Jenkins plugins.
node['jr-jenkins']['plugins'].each do |plugin|
  # Install specific version, if provided. Syntax: plugin=1.0.0
  plugin, version = plugin.split('=')
  jenkins_plugin plugin do
    version version if version
  end
end
