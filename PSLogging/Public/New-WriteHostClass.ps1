function New-WriteHostClass
{
    <#
        .SYNOPSIS
         To use the [WriteHost] Class you need to either call the New-WriteHostClass.ps1 or by loading the entire PSLogging class in the 'Class' folder. 
        
        .DESCRIPTION
         This function will create a new [WriteHost] class object and return it to the calling scope.

        .OUTPUTS
         [WriteHost] 

         This function will return a [WriteHost] class object

        .EXAMPLE 1
         C:\PS> $WriteHostLogging = New-WriteHostClass

         By calling the New-WriteHostlass function directly, it will return a [WriteHost] data type that can now be used to log to the console

        .NOTES
         New-WriteHostClass will return a class object that can be used to log to the console
    #>
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    Param
    ()

    Write-Verbose -Message 'Creating new WriteHost Class Object'

  return [WriteHost]::new()
}