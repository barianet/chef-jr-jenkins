#
# Cookbook Name:: jr-jenkins
# Resource:: view
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

actions :create, :delete
default_action :create

attribute :name, name_attribute: true, kind_of: String, required: true
attribute :jobs, kind_of: Array, required: true

attribute :template, kind_of: String, default: 'jenkins-view.xml.erb'
attribute :cookbook, kind_of: String, default: 'jr-jenkins'

attr_accessor :config
attr_accessor :exists
