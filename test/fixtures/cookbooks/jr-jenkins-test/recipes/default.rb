# Install full Jenkins suite.
include_recipe 'jr-jenkins::default'

# Test create jobs.
%w(my-job1 my-job2 my-job3).each do |job_name|
  jr_jenkins_job job_name do
    params(
      param1: 'hello',
      param2: 'world'
    )
    template 'config.xml.erb'
    cookbook 'jr-jenkins-test'
    verify_config true
  end
end

# Test updating a job.
jr_jenkins_job 'my-job1' do
  params(
    param1: 'changed',
    param2: 'world'
  )
  template 'config.xml.erb'
  cookbook 'jr-jenkins-test'
  verify_config true
end

# Test updating a job, but skip verification (should do nothing).
jr_jenkins_job 'my-job2' do
  params(
    param1: 'changed',
    param2: 'world'
  )
  template 'config.xml.erb'
  cookbook 'jr-jenkins-test'
  verify_config false
end

# Test adding a view.
jr_jenkins_view 'my-view' do
  jobs %w(my-job1 my-job2)
end

# Test jr_jenkins_job_cleanup (should remove my-job3).
chef_defined_jobs = %w(my-job1 my-job2)
jr_jenkins_job_cleanup 'job_cleanup' do
  whitelist chef_defined_jobs
end
