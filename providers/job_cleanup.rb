#
# Cookbook Name:: jr-jenkins
# Provider:: job_cleanup
#
# Author:: Ben Clark <benjamin.clark@jacksonriver.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
use_inline_resources
include Jenkins::Helper

action :execute do
  Chef::Log.debug('jr_jenkins_job_cleanup: execute begin')

  jobs = executor.groovy!('hudson.model.Hudson.instance.items.each() { println it.name }').split
  Chef::Log.debug("Jenkins jobs: #{jobs}")
  Chef::Log.debug("Jenkins jobs in whitelist: #{new_resource.whitelist}")

  if !jobs.nil? && !jobs.empty?
    # Get the diff between the real jobs and the defined jobs.
    jobs_to_remove = if jobs.class == Array && new_resource.whitelist.class == String
                       jobs - new_resource.whitelist.split(',')
                     elsif jobs.class == String && new_resource.whitelist.class == String
                       jobs.split(',') - new_resource.whitelist.split(',')
                     elsif jobs.class == String && new_resource.whitelist.class == Array
                       jobs.split(',') - new_resource.whitelist
                     else
                       jobs - new_resource.whitelist
                     end
    Chef::Log.debug("Jenkins jobs to remove: #{jobs_to_remove}")
  end

  if !jobs_to_remove.nil? && !jobs_to_remove.empty?
    jobs_to_remove.each do |remove_job|
      Chef::Log.debug("Removing Jenkins job #{remove_job}")
      executor.execute!('delete-job', remove_job)
    end
  end

  Chef::Log.debug('jr_jenkins_job_cleanup: execute end')
end
