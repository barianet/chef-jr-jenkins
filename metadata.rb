name 'jr-jenkins'
maintainer 'Ben Clark'
maintainer_email 'ben.clark@jacksonriver.com'
license 'All rights reserved'
description 'Installs/Configures Jenkins and Jenkins jobs for Jackson River'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/JacksonRiver/chef-jr-jenkins' if respond_to?(:source_url)
issues_url 'https://github.com/JacksonRiver/chef-jr-jenkins/issues' if respond_to?(:issues_url)
version '0.3.0'

depends 'apache2', '~> 2.0.0'
depends 'htpasswd'
depends 'java'
depends 'jenkins', '~> 2.4.1'
depends 'ssl_certificates', '= 1.3.2'
