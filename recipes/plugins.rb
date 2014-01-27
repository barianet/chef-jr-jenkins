#
# Cookbook Name:: jr-jenkins
# Recipe:: plugins
#
# Copyright (C) 2013 Jackson River
#
# All rights reserved - Do Not Redistribute
#

# Install Jenkins plugins.
if node['jr-jenkins']['plugins']
  node['jr-jenkins']['plugins'].each do |plugin|
    # Install specific version, if provided. Syntax: plugin=1.0.0
    plugin, version = plugin.split('=')
    jenkins_plugin plugin do
      version version if version
    end
  end
end
