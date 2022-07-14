Write-Output "Begin: Execution"

<#
    .DESCRIPTION
        An example runbook which gets all the ARM resources using the Managed Identity
    .NOTES
        AUTHOR: Azure Automation Team
        LASTEDIT: Oct 26, 2021
#>
#"Please enable appropriate RBAC permissions to the system identity of this automation account. Otherwise, the runbook may fail..."
try
{
    "Logging in to Azure..."
    Connect-AzAccount -Identity
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}
#Get all ARM resources from all resource groups
$ResourceGroups = Get-AzResourceGroup
foreach ($ResourceGroup in $ResourceGroups)
{    
    Write-Output ("Showing resources in resource group " + $ResourceGroup.ResourceGroupName)
    $Resources = Get-AzResource -ResourceGroupName $ResourceGroup.ResourceGroupName
    foreach ($Resource in $Resources)
    {
        Write-Output ($Resource.Name + " of type " +  $Resource.ResourceType)
    }
    Write-Output ("")
}

Write-Output "Begin: Set Variables"

$RGName='rg_myprod'
$SrcSQLServerName='my-src-sql-server'
$SrcSQLDBName='mySrcSqlDB'
$CopySQLServerName='my-tgt-sql-server'
$CopySQLDBName='mySrcSqlDBCopy'

Write-Output "Variable values are"
Write-Output $RGName
Write-Output $SrcSQLServerName
Write-Output $SrcSQLDBName
Write-Output $CopySQLServerName
write-Output $CopySQLDBName

Write-Output ""
Write-Output "Begin step 1: DB Copy"
Write-Output ""

$replicaDb = (Get-AzSqlDatabase -ResourceGroupName $RGName -DatabaseName $CopySQLDBName -ServerName $CopySQLServerName -ErrorAction SilentlyContinue)
 
write-Output $replicaDb
 
if($replicaDb)
{
    write-Output "Specified target Azure SQL Database already exists."
}
else
{
    write-Output "Creating a database copy using Azure Automation runbook.."   
    New-AzSqlDatabaseCopy -ResourceGroupName $RGName -ServerName $SrcSQLServerName -DatabaseName $SrcSQLDBName -CopyResourceGroupName $RGName -CopyServerName $CopySQLServerName -CopyDatabaseName $CopySQLDBName    
}
