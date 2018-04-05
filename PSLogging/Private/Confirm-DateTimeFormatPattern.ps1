<#
.Synopsis
    Confirm if a date time format pattern is valid or not

.DESCRIPTION
    Confirm if a date time format pattern is valid or not
    based on the current culture on the machine that this function
    is being ran on

.EXAMPLE 1
    PS C:\> Confirm-DateTimeFormatPattern -Format "yyyy-MM-dd HH:mm:ss"

    Format              Valid
    ------              -----
    yyyy-MM-dd HH:mm:ss  True

.EXAMPLE 2
    PS C:\> Confirm-DateTimeFormatPattern -Format "yyyy-MM-dd HH:mm:ss", "xxx-MM/dd/yy"

    Format              Valid
    ------              -----
    yyyy-MM-dd HH:mm:ss  True
    xxx-MM/dd/yy        False

.EXAMPLE 3 
    PS C:\> "yyyy-MM-dd HH:mm:ss", "xxx-MM/dd/yy", "MMMM d", "yyyy'-'MM'-'dd'T'HH':'mm':'ss.fffffffK" | Confirm-DateTimeFormatPattern

    Format                                 Valid
    ------                                 -----
    yyyy-MM-dd HH:mm:ss                     True
    xxx-MM/dd/yy                           False
    MMMM d                                  True
    yyyy'-'MM'-'dd'T'HH':'mm':'ss.fffffffK  True
#>
function Confirm-DateTimeFormatPattern
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([PSCustomObject])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]$Format
    )

    Begin
    {
        $CultureObject = ([System.Globalization.DateTimeFormatInfo]::CurrentInfo).GetAllDateTimePatterns()
    }
    Process
    {
        foreach ($item in $Format)
        {
            if ($CultureObject -contains $item)
            {
                $props = [PSCustomObject]@{
                    'Format' = $item
                    'Valid'  = $true
                }
                Write-Output $props
            }
            else
            {
                $props = [PSCustomObject]@{
                    'Format' = $item
                    'Valid'  = $false
                }
                Write-Output $props
            }
        }
    }
    End
    {
        # Intentionally Left Blank
    }
}