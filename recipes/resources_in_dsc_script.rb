dsc_script 'test' do
  code <<-EOH
    file 'test' {
      destinationpath = 'c:/test.txt'
      contents = 'hi'
    }
    windowsfeature 'powershell' {
      name = 'PowerShell'
    }
  EOH
end
