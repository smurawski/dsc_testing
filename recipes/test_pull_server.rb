#
# Cookbook Name:: .
# Recipe:: test_pull_server
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'dsc_testing::pull_server'

require 'securerandom'
guid = SecureRandom.uuid

powershell_script "Test config" do
  code <<-EOH
configuration Test {
  import-dscresource -modulename 'psdesiredstateconfiguration'
  node #{guid} {
    file "test" {
      DestinationPath = 'c:/testfile.txt'
      Contents = "Look at me"
    }
  }
}

$configpath = '#{ENV['ProgramW6432']}\\windowspowershell\\dscservice\\configuration\\'
test -outputpath $configpath
dir $configpath | % {new-dscchecksum $_.fullname}

EOH
end

directory 'c:/lcm'

powershell_script "Setup LCM" do
  code <<-EOH
[DscLocalConfigurationManager()]
configuration LCM {
  node localhost {
    Settings {
      ConfigurationMode = 'ApplyAndAutoCorrect'
      RefreshMode = 'Pull'
      ConfigurationID = '#{guid}'
      RefreshFrequencyMins = 30
      RebootNodeIfNeeded = $false
    }
    
    ConfigurationRepositoryWeb LocalPull {
      ServerUrl = 'https://localhost:8080/PSDSCPullServer.svc'
    }
  }  
}

LCM -outputpath c:/lcm/
set-dsclocalconfigurationmanager -path c:/LCM
EOH
end