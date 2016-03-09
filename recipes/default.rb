#
# Cookbook Name:: dsc_testing
# Recipe:: default
#
# Copyright (c) 2016 Steven Murawski, All Rights Reserved.

unless true # Chef::Platform.supports_dsc_invoke_resource?(node)
  Chef::Application.fatal!("Requires a Windows system with PowerShell 5.")
end

powershell_module_dir = "#{ENV['ProgramW6432']}\\WindowsPowerShell\\Modules"

remote_directory "#{powershell_module_dir}\\DscTestModule" do
  source 'DscTestModule'
  action :create
end

powershell_script 'setup powershell remoting' do
  code <<-EOH
    enable-psremoting -force -skipnetworkprofilecheck
  EOH
  guard_interpreter :ruby
  only_if node['dsc_testing']['enable_ps_remoting']
end

unless false #Chef::Platform.supports_refresh_mode_eanbled?(node) || dsc_refresh_mode_disabled?(node)
  log_message = "Configuring the LCM Refresh Mode to Disabled." \
                "  For WMF 5 builds before 10586, the LCM must be disabled" \
                " in order for dsc_resource to be used."

  log "notify_lcm_change" do
    message log_message
    action :nothing
  end

  powershell_script "Configure LCM for dsc_resource" do
    code <<-EOH
      [DscLocalConfigurationManager()]
      Configuration ConfigLCM
      {
          Node "localhost"
          {
              Settings
              {
                  ConfigurationMode = "ApplyOnly"
                  RebootNodeIfNeeded = $false
                  RefreshMode = 'Disabled'
              }
          }
      }
      ConfigLCM -OutputPath "#{Chef::Config[:file_cache_path]}\\DSC_LCM"
      Set-DscLocalConfigurationManager -Path "#{Chef::Config[:file_cache_path]}\\DSC_LCM"
    EOH
    notifies :write, 'log[notify_lcm_change]', :immediately
  end
end
