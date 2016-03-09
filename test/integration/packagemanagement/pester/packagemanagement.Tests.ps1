Describe 'PowerShellGet' {
  it 'installs PowerShellGuard' {
    get-module -list PowerShellGuard |
      should not BeNullOrEmpty
  }
}