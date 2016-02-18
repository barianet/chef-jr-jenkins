#
# Cookbook Name:: jr-jenkins
# Provider:: view
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
require 'rexml/document'
require 'shellwords'

# Support whyrun
def whyrun_supported?
  true
end

action :create do
  # Generate the XML via Template resource.
  name = "jr-jenkins-view--#{@new_resource.name}.xml"
  path = ::File.join(Chef::Config[:file_cache_path], name)
  t = Chef::Resource::Template.new(path, run_context)
  t.source(@new_resource.template)
  t.cookbook(@new_resource.cookbook)
  t.variables(
    :new_resource => @new_resource,
    :name => @new_resource.name,
    :jobs => @new_resource.jobs
  )
  t.run_action(:create)
  @new_resource.config = t.path

  if @current_resource.exists
    Chef::Log.debug("#{@new_resource} exists - skipping create")

    if correct_config?
      Chef::Log.debug("#{@new_resource} config up to date - skipping update")
    else
      converge_by("Update #{@new_resource} config") do
        executor.execute!('update-view', Shellwords.escape(@new_resource.name), '<', Shellwords.escape(@new_resource.config))
      end
    end
  else
    converge_by("Create #{@new_resource}") do
      executor.execute!('create-view', Shellwords.escape(@new_resource.name), '<', Shellwords.escape(@new_resource.config))
    end
  end
end

action :delete do
  # @todo
end

def load_current_resource
  @current_resource = Chef::Resource::JrJenkinsView.new(@new_resource.name)
  @current_resource.jobs(@new_resource.jobs)
  @current_resource.template(@new_resource.template)

  if current_view
    @current_resource.exists  = true
  else
    @current_resource.exists  = false
  end

  @current_resource
end

#
# The view in the current, in XML format.
#
# @return [nil, Hash]
#   nil if the view does not exist, or a hash of important information if
#   it does
#
def current_view
  return @current_view if @current_view

  Chef::Log.debug "Load #{@new_resource} view information"

  response = executor.execute('get-view', Shellwords.escape(@new_resource.name))
  return nil if response.nil? || response =~ /No view named/

  Chef::Log.debug "Parse #{@new_resource} as XML"
  xml = REXML::Document.new(response.rstrip)

  @current_view = {
    :xml => xml,
    :raw => response
  }
  @current_view
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

  current_view[:xml].write(current, 2)
  REXML::Document.new(::File.read(@new_resource.config).rstrip).write(wanted, 2)

  current.string == wanted.string
end
