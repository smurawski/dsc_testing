
function Get-TargetResource
{
    [OutputType([Hashtable])]
    param (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,
        [parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $InstanceArray
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $InstanceArray
    )

  

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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $InstanceArray
    )

    $false
}
