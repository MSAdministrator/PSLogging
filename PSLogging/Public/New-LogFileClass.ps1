function New-LogFileClass
{
    <#
        .SYNOPSIS
         To use the [LogFile] Class you need to either call the New-LogFileClass.ps1 or by loading the entire PSLogging class in the 'Class' folder. 
        
        .DESCRIPTION
         This function will create a new [LogFile] class object and return it to the calling scope.

        .PARAMETER LogFile
         LogFile is the file path and log you want to create and begin logging to

        .INPUTS
         System.String

         Pass in a string value for the path to create a LogFile

        .OUTPUTS
         [LogFile] 

         This function will return a [LogFile] class object

        .EXAMPLE 1
         C:\PS> $LogFile = New-LogFileClass -LogFile 'C:\path\to\log\file\log.log'

         By calling the New-LogFileClass function directly, it will return a [LogFile] data type that can now be used to log to

        .EXAMPLE 2
         C:\PS> $LogFile = New-LogFileClass -LogFile 'C:\path\to\log\file\log.txt'

         By calling the New-LogFileClass function directly, it will return a [LogFile] data type that can now be used to log to

        .NOTES
         New-LogFileClass will return a class object that can be used to log to a specified Log File / text file
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