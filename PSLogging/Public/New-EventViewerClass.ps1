function New-EventViewerClass
{
    <#
        .SYNOPSIS
         To use the [EventViewer] Class you need to either call the New-EventViewerClass.ps1 or by loading the entire PSLogging class in the 'Class' folder. 
        .DESCRIPTION

        .PARAMETER LogName

        .PARAMETER LogSource

        .PARAMETER LogName

        .INPUTS

        .OUTPUTS

        .EXAMPLE
         $EventViewerLogging = New-EventViewerClass -LogName 'Some LogName' -LogSource 'Some LogSource'

         By calling the New-EventViewerClass function directly, it will return a [EventViewer] data type that can now be used to log to

        .NOTES
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

  return [EventViewer]::new($LogName, $LogSource)
}