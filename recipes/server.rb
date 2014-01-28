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

# Set up Jenkins admin user.
include_recipe "jr-jenkins::user"

# Set up Jenkins plugins.
include_recipe "jr-jenkins::plugins"

# Set up Apache proxy.
include_recipe "jr-jenkins::proxy"
