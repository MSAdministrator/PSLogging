using module .\Class\PSLogging.psm1
# Above needs to remain the first line to import the PSLogging Classes
<#
$OutputParams = [PSCustomObject]@{
    'Console' = @{
		'datetime'      = 'yyyy-MM-dd HH:mm:ss'
		'displaySource' = $true
        'level'         = 'DEBUG'
    }
    'info' = @{
		'datetime'      = 'yyyy-MM-dd HH:mm:ss'
		'displaySource' = $true
		'level'         = 'INFO'
		'filename'      = 'info.log'
		'maxBytes'      = 10485760
		'encoding'      = 'utf8'
    }
    'success' = @{
		'datetime'      = 'yyyy-MM-dd HH:mm:ss'
		'displaySource' = $true
		'level'         = 'SUCCESS'
		'filename'      = 'success.log'
		'maxBytes'      = 10485760
		'encoding'      = 'utf8'
    }
    'warning' = @{
		'datetime'      = 'yyyy-MM-dd HH:mm:ss'
		'displaySource' = $true
		'level'         = 'WARNING'
		'filename'      = 'warning.log'
		'maxBytes'      = 10485760
		'encoding'      = 'utf8'
    }
    'error' = @{
		'datetime'      = 'yyyy-MM-dd HH:mm:ss'
		'displaySource' = $true
		'level'         = 'ERROR'
		'filename'      = 'error.log'
		'maxBytes'      = 10485760
		'encoding'      = 'utf8'
    }
}#>

#requires -Version 2
#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue )

<#
if (-not(Get-Module -Name PSSlack))
{
    Install-Module -Name PSSlack
}

if (-not (Test-Path $env:TEMP\$env:USERNAME-$env:COMPUTERNAME-PSLogging.xml -ErrorAction SilentlyContinue))
{
    try
    {
        Write-Warning -Message "Did not find $env:TEMP\$env:USERNAME-$env:COMPUTERNAME-PSLogging.xml configuration file, attempting to create"
        $OutputParams | Export-Clixml -Path $env:TEMP\$env:USERNAME-$env:COMPUTERNAME-PSLogging.xml -Force -ErrorAction Stop

    }
    catch
    {
        Write-Warning -Message "Failed to create $env:TEMP\$env:USERNAME-$env:COMPUTERNAME-PSLogging.xml configuration file: $_"
    }
}
#>

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function *