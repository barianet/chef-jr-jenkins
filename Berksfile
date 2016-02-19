source 'https://api.berkshelf.com'

# Load from cookbook metadata.rb dependencies
metadata

# Specify specific versions/sources of dependencies
cookbook 'jenkins', '~> 2.4.1'
cookbook 'ssl_certificates', '~> 1.3.0', :github => 'benclark/chef-ssl_certificates'

group :integration do
  cookbook 'jr-jenkins_job', :path => 'test/fixtures/cookbooks/jr-jenkins_job'
end
