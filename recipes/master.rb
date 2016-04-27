#
# Cookbook Name:: jr-jenkins
# Recipe:: master
#
# Copyright (c) 2016 Jackson River, All Rights Reserved.

# Install Java.
include_recipe 'java'

# Install Jenkins master.
include_recipe 'jenkins::master'
