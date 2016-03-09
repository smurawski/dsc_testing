#
# Cookbook Name:: dsc_testing
# Recipe:: pull_server
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'dsc_testing::prep_package_management'

powershell_script 'Install xPSDesiredStateConfiguration' do
  code <<-EOH
ipmo powershellget -force
install-module xPSDesiredStateConfiguration -force
EOH
  only_if "(Get-Module -list xPSDesiredStateConfiguration) -eq $null" 
end

dsc_resource 'DSC Service' do
  resource :windowsfeature
  property :name, 'DSC-Service'
end

powershell_script 'Cert' do
  code <<-EOH
new-selfsignedcertificate -dnsname "PSDSCPullServerCert", "localhost" -certstore cert:/localmachine/my
EOH
  not_if '(dir cert:/localmachine/my/ | where {$_.subject -like "CN=PSDSCPullServerCert"}) -ne $null'
end

dsc_resource 'pull server' do
  resource :xDscWebService
  property :EndpointName, 'PullServer'
  property :Port, 8080
  property :PhysicalPath, "#{ENV['SYSTEMDRIVE']}\\inetpub\\psdscpullserver"
  property :ModulePath, "#{ENV['ProgramW6432']}\\windowspowershell\\dscservice\\modules"
  property :ConfigurationPath, "#{ENV['ProgramW6432']}\\windowspowershell\\dscservice\\configuration"
  property :State, 'Started'
  property :CertificateThumbprint, lazy { powershell_out!('dir cert:/localmachine/my | where {$_.subject -like \"CN=PSDSCPullServerCert\"} | select -expand Thumbprint').stdout.chomp }
end
