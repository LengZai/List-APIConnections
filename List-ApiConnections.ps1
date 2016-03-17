<#
 .SYNOPSIS
 List the API connections in the subscription.

 .DESCRIPTION
 List the set of Logic App Api connections created in your subscription.  Specify the api name to just get the Api connections for that Api.

 .PARAMETER ApiName
 Name of the Api for which you want to see connections.

 .EXAMPLE
 ./List-ApiConnections.ps1
 List all Api connections in your subscription

 .EXAMPLE
 ./List-ApiConnections.ps1 dropbox
 List all Api connections for the dropbox api in your subscription

 .NOTES
 To run this script you may need to change your powershell execution policy using, for example, set-executionpolicy 
 
#>
param([string]$ApiName)
$resources = Find-AzureRmResource -ResourceType microsoft.web/connections
if ($ApiName) {
    foreach($r in $resources)
    {
        $robj = Get-AzureRmResource -ResourceId $r.ResourceId
        if ($robj.Properties.Api.Name -like $ApiName)
        {
            $robj |Select-Object @{Name="Api";Expression={$_.Properties.Api.Name}}, @{Name="ConnectionName";Expression={$_.Properties.DisplayName}}, @{Name="ConnectionConfig";Expression={$_.Properties.NonSecretParameterValues}}, Name, ResourceId, ResourceName, ResourceType, ResourceGroupName, Location, SubscriptionId
        }
    }
} else {
    foreach($r in $resources)
    {
        Get-AzureRmResource -ResourceId $r.ResourceId | Select-Object @{Name="Api";Expression={$_.Properties.Api.Name}}, @{Name="ConnectionName";Expression={$_.Properties.DisplayName}}, @{Name="ConnectionConfig";Expression={$_.Properties.NonSecretParameterValues}}, Name, ResourceId, ResourceName, ResourceType, ResourceGroupName, Location, SubscriptionId
    }
}
