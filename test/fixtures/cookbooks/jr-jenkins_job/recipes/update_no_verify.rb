include_recipe 'jr-jenkins::default'

# Test updating a job, but skipping verification.
jr_jenkins_job 'my-job' do
  params(
    :param1 => 'hello',
    :param2 => 'world'
  )
  template 'config.xml.erb'
  cookbook 'jr-jenkins_job'
  verify_config false
end

# Test jr_jenkins_job_cleanup
chef_defined_jobs = ['testclient-core', 'testclient-salesforce']
jr_jenkins_job_cleanup chef_defined_jobs do
  only_if { node['jr-hosted-springboard']['jenkins_job_cleanup'] }
end
