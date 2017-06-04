function New-EventViewerClass
{
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