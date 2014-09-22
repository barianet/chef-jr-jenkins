include_recipe 'jr-jenkins::default'

# Test basic job creation
jr_jenkins_job 'my-job' do
  params(
    'param1' => 'hello',
    'param2' => 'world'
  )
  template 'config.xml.erb'
  cookbook 'jr-jenkins_job'
end
