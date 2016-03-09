#
# Cookbook Name:: .
# Recipe:: prep_packagemangement
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

powershell_script 'Make Sure Nuget.exe is around' do
  code <<-EOH
ipmo PackageManagement -force
install-packageprovider Nuget -forcebootstrap -force
EOH
end