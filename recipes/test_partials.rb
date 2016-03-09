#
# Cookbook Name:: .
# Recipe:: partial_config
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'dsc_testing::pull_server'

require 'securerandom'
guid = SecureRandom.uuid

directory 'c:/tempconfig'
directory 'c:/tempconfig/BaseConfig'
directory 'c:/tempconfig/ThoseOtherPeople'

powershell_script "Test config" do
  code <<-EOH
configuration BaseConfig {
  import-dscresource -modulename 'psdesiredstateconfiguration'
  node #{guid} {
    file "test1" {
      DestinationPath = "c:/testfile-BaseConfig.txt"
      Contents = "From BaseConfig"
    }
  }
}
configuration ThoseOtherPeople {
  import-dscresource -modulename 'psdesiredstateconfiguration'
  node #{guid} {
    file "test2" {
      DestinationPath = "c:/testfile-ThoseOtherPeople.txt"
      Contents = "From ThoseOtherPeople"
    }
  }
}

BaseConfig -outputpath c:/tempconfig/BaseConfig
ThoseOtherPeople -outputpath c:/tempconfig/ThoseOtherPeople

$configpath = '#{ENV['ProgramW6432']}\\windowspowershell\\dscservice\\configuration\\'
move-item c:/tempconfig/BaseConfig/#{guid}.mof -dest (join-path $configpath "BaseConfig.#{guid}.mof")
move-item c:/tempconfig/ThoseOtherPeople/#{guid}.mof -dest (join-path $configpath "ThoseOtherPeople.#{guid}.mof")
dir $configpath | % {new-dscchecksum $_.fullname}
EOH
end

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

    PartialConfiguration BaseConfig {
      Description = "For the real admins"
      ConfigurationSource = '[ConfigurationRepositoryWeb]LocalPull'
      RefreshMode = 'Pull'
    }

    PartialConfiguration ThoseOtherPeople {
      Description = "For those other people that needs stuff on this box"
      ConfigurationSource = '[ConfigurationRepositoryWeb]LocalPull'
      DependsOn = '[PartialConfiguration]BaseConfig'
      RefreshMode = 'Pull'
    }
  }
}

if (-not (test-path c:/lcm)) {
  mkdir c:/lcm | out-null
}
LCM -outputpath c:/lcm/
set-dsclocalconfigurationmanager -path c:/LCM
EOH
end