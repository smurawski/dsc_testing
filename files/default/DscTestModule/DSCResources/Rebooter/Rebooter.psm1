
function Get-TargetResource
{
    [OutputType([Hashtable])]
    param (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,
        [parameter()]
        [ValidateSet('True','False')]
        [string]
        $Reboot = 'False'
    )

    #Needs to return a hashtable that returns the current
    #status of the configuration component

    $Configuration = @{
        Name = (tzutil /g)
        Ensure = 'Present'
    }

    return $Configuration
}

function Set-TargetResource
{
    param (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,
        [parameter()]
        [ValidateSet('True','False')]
        [string]
        $Reboot = 'False'
    )

    if ($Reboot -like 'True')
    {
        $global:DSCMachineStatus = 1
    }


}

function Test-TargetResource
{
    [OutputType([boolean])]
    param (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,
        [parameter()]
        [ValidateSet('True','False')]
        [string]
        $Reboot = 'False'
    )

    $false
}
