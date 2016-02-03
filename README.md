# dsc_testing Cookbook

## Purpose:

This cookbook exists to validate some edge cases and different scenarios with how Chef interacts with DSC via Invoke-DSCResource.

Since the DSC LCM is really picky about types and we are going from Ruby to PowerShell to WMI, there is a bunch of room for error. 


## Recipes:

### default

Makes sure PowerShell remoting is enabled and that the LCM is configured so that invoke-dscresource can be used.

### with_hashes

Tests how ruby hashes are used by resources that take Key/Value CIM instances.

Validates both hashes and Chef::Node::ImmutableMash (attributes)

### reboot_pending

Tests reboot_action's response when a DSC resource flags that a reboot was needed. 
