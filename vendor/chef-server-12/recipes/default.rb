#
# Cookbook Name:: chef-server-12
# Recipe:: default
#
# Author:: Salim Afiune (<afiune@chef.io>)
#
# Copyright:: Copyright (c) 2015 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

directory "/etc/opscode" do
  recursive true
end

chef_server_ingredient 'chef-server-core' do
  notifies :reconfigure, 'chef_server_ingredient[chef-server-core]'
end

template "/etc/opscode/chef-server.rb" do
  owner "root"
  mode "0644"
  notifies :run, "execute[reconfigure chef]", :immediately
end

execute "reconfigure chef" do
  command "chef-server-ctl reconfigure"
  action :nothing
end

# Install Enabled Plugins
node['chef-server-12']['plugin'].each do |feature, enabled|
  install_plugin(feature) if enabled
end

# Delivery Setup?
include_recipe "chef-server-12::delivery_setup" if node['chef-server-12']['delivery_setup']