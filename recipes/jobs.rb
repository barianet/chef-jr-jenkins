#
# Cookbook Name:: jr-jenkins
# Recipe:: jobs
#
# Copyright (C) 2013 Jackson River
#
# All rights reserved - Do Not Redistribute
#

include_recipe "jenkins"

# Get all the jobs from the data_bags.
jenkins_jobs = data_bag('jenkins-jobs')

jenkins_jobs.each do |job_name|
  # Get data for this job.
  job_data = data_bag_item('jenkins-jobs', job_name)

  job_config = File.join(Chef::Config[:file_cache_path], "#{job_name}--config.xml")

  jenkins_job job_name do
    action :nothing
    config job_config
  end

  template job_config do
    source "jenkins-shell-job.xml.erb"
    variables({
      'description' => job_data['description'] || "Missing description for job #{job_name}",
      'logrotator' => job_data['logrotator'] || {},
      'cron_timer' => job_data['cron_timer'],
      'shell_command' => job_data['shell_command']
    })
    notifies :update, resources(:jenkins_job => job_name)
  end

end
