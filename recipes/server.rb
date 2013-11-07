#
# Cookbook Name:: jr-jenkins
# Recipe:: server
#
# Copyright (C) 2013 Jackson River
#
# All rights reserved - Do Not Redistribute
#

include_recipe "jenkins::server"
include_recipe "jenkins::proxy"
