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
}

describe 'After configuration has applied' {
  it 'has a file c:/testfile.txt' {
    test-path c:/testfile.txt | should be $true
  }
  it 'has a testfile with the right content' {
    'c:/testfile.txt' | should contain 'Look\sat\sme'
  }
}