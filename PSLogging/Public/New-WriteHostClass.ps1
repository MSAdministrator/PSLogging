function New-WriteHostClass
{
    <#
        .SYNOPSIS
        Placeholder

        .DESCRIPTION
        Placeholder

        .PARAMETER LogFile
        Placeholder

        .INPUTS
        Placeholder

        .OUTPUTS
        Placeholder

        .EXAMPLE
        Placeholder

        .NOTES
        Placeholder
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

  return [WriteHost]::new()
}