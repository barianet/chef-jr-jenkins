include_recipe 'jr-jenkins::default'

# config = File.join(Chef::Config[:file_cache_path], 'job-config.xml')
# template(config) { source 'config.xml.erb' }

# Test basic job creation
# jenkins_job 'my-project' do
#   config config
# end
