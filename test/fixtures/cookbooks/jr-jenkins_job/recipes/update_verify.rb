include_recipe 'jr-jenkins::default'

# Test updating a job (by verifying config).
jr_jenkins_job 'my-job' do
  params(
    'param1' => 'hello again, ',
    'param2' => 'world'
  )
  template 'config.xml.erb'
  cookbook 'jr-jenkins_job'
  verify_config true
end
