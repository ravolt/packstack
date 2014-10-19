# Copyright 2014, Greg Althaus
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

packstack_user = (node["packstack"]["user"] || "packstack" rescue "packstack")

rel = (node["packstack"]["openstack_release"] rescue nil)
case rel
when "juno"
  packstack_source = "http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm"
when "icehouse"
  packstack_source = "http://rdo.fedorapeople.org/rdo-release.rpm"
else
  packstack_source = "http://rdo.fedorapeople.org/rdo-release.rpm"
end

# yum udpate -y
bash "Update system for packstack" do
  code "yum update -y"
end

# Add repos
bash "Load packstack repos" do
  code "yum install -y #{packstack_source}"
  not_if "rpm -qa | grep -q rdo-release"
end

package "openstack-packstack"

# Make user
user packstack_user do
  supports :manage_home => true
  comment "Packstack User"
  shell "/bin/bash"
end

directory "/home/#{packstack_user}/.ssh" do
  mode 0700
  owner packstack_user
  group packstack_user
end

# Make key
bash "Make ssh #{packstack_user} ssh key" do
  code "ssh-keygen -t rsa -f /home/#{packstack_user}/.ssh/id_rsa -P ''"
  not_if "test -f /home/#{packstack_user}/.ssh/id_rsa.pub"
end

file "/home/#{packstack_user}/.ssh/id_rsa" do
  mode 0600
  owner packstack_user
  group packstack_user
end

file "/home/#{packstack_user}/.ssh/id_rsa.pub" do
  mode 0600
  owner packstack_user
  group packstack_user
end

# Record key
ruby_block "Record Packstack Keys" do
  block do
    node.normal['packstack'] ||= Mash.new
    node.normal['packstack']['public_key'] = %x{cat /home/#{packstack_user}/.ssh/id_rsa.pub}
    node.normal['packstack']['private_key'] = %x{cat /home/#{packstack_user}/.ssh/id_rsa}
  end
end

