function New-EventViewerClass
{
    <#
        .SYNOPSIS
         To use the [EventViewer] Class you need to either call the New-EventViewerClass.ps1 or by loading the entire PSLogging class in the 'Class' folder. 
        .DESCRIPTION
         This function will create a new [EventViewer] class object and return it to the calling scope.

        .PARAMETER LogName
         LogName is the Event Viewer folder name you want your logs to go to

        .PARAMETER LogSource
         LogSource is the name displayed in each event's source column in the Event Viewer

        .INPUTS
         PSCustomObject

         You can create a custom hashtable or object and pipe it into this function

        .OUTPUTS
         [EventViewer] 

         This function will return a [EventViewer] class object

        .EXAMPLE
         C:\PS> $EventViewerLogging = New-EventViewerClass -LogName 'Some LogName or Event Viewer folder' -LogSource 'Some LogSource'

         By calling the New-EventViewerClass function directly, it will return a [EventViewer] data type that can now be used to log to

        .NOTES
         New-EventViewerClass will return a class object that can be used to log to the Event Viewer Log
    #>

    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    Param
    (
        # Provide a log name
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$LogName, 
        
        # Provide a log source
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [string]$LogSource
    )

    Write-Verbose -Message 'Creating new EventViewer Class Object'

    if ([Diagnostics.EventLog]::SourceExists($LogSource))
    {
        $confirmation = Read-Host "The LogSource $LogSource already exists. Are you Sure You Want To Proceed:"

        if ($confirmation -eq 'y') 
        {
            return [EventViewer]::new($LogName, $LogSource)
        }
        else
        {
            return $null    
        }
    }
    else
    {
        return [EventViewer]::new($LogName, $LogSource)
    }
}