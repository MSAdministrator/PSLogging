function New-LogFileClass
{
    <#
        .SYNOPSIS

        .DESCRIPTION

        .PARAMETER LogFile

        .INPUTS

        .OUTPUTS

        .EXAMPLE

        .NOTES
    #>
    
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $LogFile
    )

  return [LogFile]::new($LogFile)
}