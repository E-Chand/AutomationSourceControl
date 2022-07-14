try
{
    "Logging in to Azure..."
    Connect-AzAccount -Identity
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}


# Set Variables
$TargetServerInstance='my-tgt-sql-server.database.windows.net'
$TargetServerDatabase='mySrcSqlDBCopy'
$QueryToGetTargetDatabaseNames="EXEC mySrcSqlDBCopy.dbo.sproc_insertdata 'Azure Automation'"



$TargetServerCredentials = 'tgtSqlServer'

# Get credentials object:
$Credentials = Get-AutomationPSCredential -Name $TargetServerCredentials


# Execute Sproc on target server
Invoke-Sqlcmd -ServerInstance $TargetServerInstance -Database $TargetServerDatabase -UserName $Credentials.UserName -Password $Credentials.GetNetworkCredential().Password -Query $QueryToGetTargetDatabaseNames -Verbose 
