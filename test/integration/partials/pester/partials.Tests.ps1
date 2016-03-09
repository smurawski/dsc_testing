describe 'Pull Server' {
  it 'is installed' {
    (get-windowsfeature dsc-service).installed | should be $true
  }
  it 'is listening on :8080' {
    ipmo webadministration -Force
    (Get-Item iis://sites/pullserver).bindings.collection.bindingInformation |
      should match '8080'
  }
  it 'has ssl enabled' {
    ipmo webadministration -Force
    (Get-Item iis://sites/pullserver).bindings.collection.sslFlags |
      should be 0
  }
}

describe 'Pull Server Contents' {
  it 'has a checksum per MOF file' {
    $mofs = dir $env:ProgramFiles/WindowsPowerShell/DscService/Configuration/*.mof
    $checksums = $mofs | where {test-path "$($_.fullname).checksum"}
    $checksums.count | should be $mofs.count
  }

  it 'has a BaseConfig partial configuration' {
    dir $env:ProgramFiles/WindowsPowerShell/DscService/Configuration/BaseConfig.*.mof |
      should not benullorempty
  }

  it 'has a ThoseOtherPeople partial configuration' {
    dir $env:ProgramFiles/WindowsPowerShell/DscService/Configuration/ThoseOtherPeople.*.mof |
      should not benullorempty
  }
}

describe 'Testing Partial Configuration' {

  it 'successfully converges' {
    Update-DscConfiguration -Wait
    (Get-DscConfigurationStatus).Status | 
      should be 'Success'
  }

  it 'has a file c:/testfile-BaseConfig.txt' {
    test-path c:/testfile-BaseConfig.txt | should be $true
  }
  it 'has a file c:/testfile-ThoseOtherPeople.txt' {
    test-path c:/testfile-ThoseOtherPeople.txt | should be $true
  }
}