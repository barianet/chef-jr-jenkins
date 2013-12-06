#
# Cookbook Name:: jr-jenkins
# Attributes:: server
#

# Jenkins settings
default['jenkins']['http_proxy']['variant'] = 'apache2'

# Apache settings
default['apache']['timeout'] = 30
default['apache']['keepalive'] = 'Off'
default['apache']['servertokens'] = 'Prod'
default['apache']['serversignature'] = 'Off'
default['apache']['traceenable'] = 'Off'
default['apache']['prefork']['startservers'] = 4
default['apache']['prefork']['minspareservers'] = 1
default['apache']['prefork']['maxspareservers'] = 4
default['apache']['prefork']['serverlimit'] = 10
default['apache']['prefork']['maxclients'] = 10
default['apache']['prefork']['maxrequestsperchild'] = 10_000
