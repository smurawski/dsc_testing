#
# Cookbook Name:: .
# Recipe:: test_package_mgmt
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'dsc_testing::prep_package_management'

powershell_script 'Install PowerShellGuard' do
  code <<-EOH
ipmo powershellget -force
install-module PowerShellGuard -force
EOH
end