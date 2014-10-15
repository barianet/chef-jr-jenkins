name 'jr-jenkins'
maintainer 'Ben Clark'
maintainer_email 'benjamin.clark@jacksonriver.com'
license 'All rights reserved'
description 'Installs/Configures Jenkins and Jenkins jobs'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.14'

depends 'apache2'
depends 'htpasswd'
depends 'java'
depends 'jenkins', '~> 2.0.0'
depends 'openssl', '~> 1.1'
depends 'ssl_certificates'
