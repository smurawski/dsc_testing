#
# Cookbook Name:: dsc_testing
# Recipe:: reboot_pending
#
# Copyright (c) 2016 Steven Murawski, All Rights Reserved.

dsc_resource 'Do not require reboot' do
  resource :rebooter
  module_name 'DscTestModule'
  property :name, 'Sample without reboot'
  property :Reboot, 'false'
  reboot_action :request_reboot
end

dsc_resource 'Require reboot' do
  resource :rebooter
  module_name 'DscTestModule'
  property :name, 'Sample with reboot'
  property :Reboot, 'true'
  reboot_action :request_reboot
end

reboot 'Cancel reboot' do
  action :cancel
  reason 'I do not really want to reboot now.'
end
