# PSLogging
A PowerShell V5 class that can log to:
* A File
* The console
* The Windows Event Viewer

## Synopsis
Used to create and output information from functions to a specific (or all three) log types
* A File
* The console
* The Windows Event Viewer

## DESCRIPTION
This function will write to a all or one log type.  Each log type can have a specified log type of:
	
        Informational (Info)
	Success (Success)
	Warning (Warning)
        Debugging (Debug)
        Error (Error)
	Error (Error & ErrorRecord)

This Class can be used directly by loading the 'PSLogging.ps1' file in the 'Private' folder or by using one of the functions contained in the 'Public' folder.  
* New-EventViewerClass
* New-LogFileClass
* New-WriteHostClass

## Using the [EventViewer] Class
To use the [EventViewer] Class you need to either call the New-EventViewerClass.ps1 or by loading the entire PSLogging class in the 'Private' folder.  

### New-EventViewerClass
```
$EventViewerLogging = New-EventViewerClass -LogName 'Some LogName' -LogSource 'Some LogSource'
```

### PSLogging Class
```
$EventViewrLogging = [EventViewer]::new('Some LogName','Some LogSource')
```

Either way, the EventViewer Class has multiple settings and configurations that you can use.  After creating your new variable ($EventViewerLogging) you can use it to log information to the event viewer.  Here are some examples of the type of logging you can do:

```
$EventViewerLogging.Info('Logging to Some LogSource as informational text')
$EventViewerLogging.Success('Logging to Some LogSource as success text')
$EventViewerLogging.Info('Logging to Some LogSource as informational text')
```
This function will by default create a log file in the parent folder of the calling scope, but
   you can specify a seperate log location if you choose.
```
$ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(‘.\’)\log.log
```
   
   The default parameter set for this function is the Info logging, but there are 2 other sets
        Debug
        Error
   
## EXAMPLE
   Function call
```
Write-LogEntry -Info 'This is an informational log event'
```
    Output
```
20170401T055438 [INFO]: This is an informational log event
```
## EXAMPLE
   Function call
```
Write-LogEntry -Debugging 'This is an debugging log event'
```
    Output
```
20170401T055440 [DEBUG]: This is an debugging log event
```
## EXAMPLE
    Function call
```
Write-LogEntry -Error 'This is an error log event'
```
    Output
```
20170401T055442 [ERROR]: This is an error log event
```
## EXAMPLE
    Function call
```
try { 
   do-something 
} catch { 
   Write-LogEntry -Error 'This is an error log event' -ErrorRecord $Error[0] 
}
```
    Output
```
20170401T055444 [ERROR]: This is an error log event
20170401T055444 [ERROR]: The term 'do-something' is not recognized as the name of a cmdlet, `
                         function, script file, or operable program. Check the spelling of the name, `
                         or if a path was included, verify that the path is correct and try again. `
                         (CommandNotFoundException: :1 char:7)
```

## INPUTS
```
System.String
System.Management.Automation.ErrorRecord
```
## NOTES
   Name: Write-LogEntry
   Created by: Josh Rickard
   Created Date: 04/01/2017
## FUNCTIONALITY
   Write-LogEntry is a PowerShell helper function that will accept or create a log file and
   add strings based on severity, as well as parse $error[0] records for easy interpretation
   and readability.