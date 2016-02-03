
function Get-TargetResource
{
    [OutputType([Hashtable])]
    param (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,
        [parameter()]
        [CIMInstance[]]
        $HashTable
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
        [CIMInstance[]]
        $HashTable
    )

    foreach ($one in $HashTable){
      Write-Verbose "`tKey: $($one.key)"
      Write-Verbose "`tValue: $($one.value)"
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
        [CIMInstance[]]
        $HashTable
    )

    $false
}



