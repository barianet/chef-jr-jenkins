#
# Cookbook Name:: jr-jenkins
# Provider:: job
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

include Jenkins::Helper
require 'rexml/document'
require 'shellwords'

# Support whyrun
def whyrun_supported?
  true
end

action :create do
  # Generate the XML via Template resource.
  name = "jr-jenkins-job--#{@new_resource.name}.xml"
  path = ::File.join(Chef::Config[:file_cache_path], name)
  t = Chef::Resource::Template.new(path, run_context)
  t.source(@new_resource.template)
  t.cookbook(@new_resource.cookbook)
  t.variables(
    :new_resource => @new_resource,
    :name => @new_resource.name,
    :params => @new_resource.params,
  )
  t.run_action(:create)
  @new_resource.config = t.path

  # Check whether the job exists in Jenkins.
  if @current_resource.exists
    Chef::Log.debug("#{@new_resource} exists - skipping create")

    # Job exists, check whether we need to run update-job.
    if verify_config?
      if correct_config?
        Chef::Log.debug("#{@new_resource} config up to date - skipping update")
      else
        # Update the config to match the templated config.
        converge_by("Update #{@new_resource} config") do
          executor.execute!('update-job', Shellwords.escape(@new_resource.name), '<', Shellwords.escape(@new_resource.config))
        end
      end
    else
      # Job exists, but we're not verifying the config.
      Chef::Log.debug("#{new_resource} exists - skipping config verification")
    end
  else
    # Create the job in Jenkins.
    converge_by("Create #{@new_resource}") do
      executor.execute!('create-job', Shellwords.escape(@new_resource.name), '<', Shellwords.escape(@new_resource.config))
    end
  end
end

action :delete do
  # @todo
end

def load_current_resource
  @current_resource = Chef::Resource::JrJenkinsJob.new(@new_resource.name)
  @current_resource.params(@new_resource.params)
  @current_resource.template(@new_resource.template)
  @current_resource.cookbook(@new_resource.cookbook)
  @current_resource.verify_config(@new_resource.verify_config)

  if job_exists?
    @current_resource.exists = true
  else
    @current_resource.exists = false
  end

  @current_resource
end

#
# Validate that the job exists.
#
# There is a speed boost if the master backend is on localhost, because we can
# check the filesystem for the config.xml, rather than querying the backend via
# the CLI jar, which requires overhead.
#
def job_exists?
  if node['jenkins']['master']['host'] == 'localhost'
    ::File.exist?(::File.join(node['jenkins']['master']['home'], 'jobs', @new_resource.name, 'config.xml'))
  else
    current_job
  end
end

#
# The job in the current, in XML format.
#
# @return [nil, Hash]
#   nil if the job does not exist, or a hash of important information if
#   it does
#
def current_job
  return @current_job if @current_job

  Chef::Log.debug "Load #{@new_resource} job information"

  response = executor.execute('get-job', Shellwords.escape(@new_resource.name))
  return nil if response.nil? || response =~ /No job named/

  Chef::Log.debug "Parse #{@new_resource} as XML"
  xml = REXML::Document.new(response.rstrip)

  @current_job = {
    :xml => xml,
    :raw => response
  }
  @current_job
end

#
# Helper method for determining if the given JSON is in sync with the
# current configuration on the Jenkins master.
#
# We have to create REXML objects and then remove any whitespace because
# XML is evil and sometimes sucks at the simplest things, like comparing
# itself.
#
# @return [Boolean]
#
def correct_config?
  current = StringIO.new
  wanted  = StringIO.new

  current_job[:xml].write(current, 2)
  REXML::Document.new(::File.read(@new_resource.config).rstrip).write(wanted, 2)

  current.string == wanted.string
end

#
# Helper method for determining whether we need to verify the config.
#
# @return [Boolean]
#
def verify_config?
  @new_resource.verify_config
end
