#
# Cookbook Name:: jr-jenkins
# Recipe:: default
#
# Copyright (c) 2016 Jackson River, All Rights Reserved.

# Set up Jenkins.
include_recipe 'jr-jenkins::master'

# Set up Jenkins credentials.
include_recipe 'jr-jenkins::user'

# Set up Jenkins plugins.
include_recipe 'jr-jenkins::plugins'

# Set up Apache proxy.
include_recipe 'jr-jenkins::proxy'
