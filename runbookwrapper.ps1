# Ensure that the runbook does not inherit an AzContext
Disable-AzContextAutosave -Scope Process

# Connect to Azure with system-assigned managed identity
#$AzureContext = (Connect-AzAccount -Identity).context

# Connect to Azure with user-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity -AccountId '99f47f9f-7603-4b9a-818c-5efa34d591bc').context

# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext

Write-Output "Line added to check source code integration"

Write-Output ""
Write-Output "Executing runbook to copy SQL db"
Write-Output ""

#$params = @{"VMName"="MyVM";"RepeatCount"=2;"Restart"=$true}

Start-AzAutomationRunbook `
    -AutomationAccountName 'myAutomationAccount' `
    -Name 'one_sqldbcopy' `
    -ResourceGroupName 'rg_myprod' `
    -DefaultProfile $AzureContext `
	-Wait
#    -Parameters $params -Wait


Write-Output ""
Write-Output "Executing runbook to execute SQL script on target DB"
Write-Output ""

Start-AzAutomationRunbook `
    -AutomationAccountName 'myAutomationAccount' `
    -Name 'three_executeSQLscripts' `
    -ResourceGroupName 'rg_myprod' `
    -DefaultProfile $AzureContext `
	-Wait
