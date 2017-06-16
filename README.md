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
To use the [EventViewer] Class you need to either call the New-EventViewerClass.ps1 or by loading the entire PSLogging class in the 'Class' folder.  

### New-EventViewerClass
```
$EventViewerLogging = New-EventViewerClass -LogName 'Some LogName' -LogSource 'Some LogSource'
```

### PSLogging Class
There are several overload methods that can be used when creating a new EventViewer log and source.  Below contains all the overloads, and they are self explanatory
```
$EventViewrLogging = [EventViewer]::new('Some LogName','Some LogSource')
$EventViewrLogging = [EventViewer]::new('Some LogName','Some LogSource', 'computer01')
$EventViewrLogging = [EventViewer]::new('Some LogName','Some LogSource', 'c:\path\to\resource\file\resource.xml')
```

The EventViewer Class has multiple settings and configurations that you can use.  After creating your new variable ($EventViewerLogging) you can use it to log information to the event viewer.  There are several overload defintions for each of the logging types listed above and here for reference:
```
        Informational (Info)
	Success (Success)
	Warning (Warning)
        Debugging (Debug)
        Error (Error)
	Error (Error & ErrorRecord)
```
Each of the overload definitions for the Event Viewer portion of this class allow you to specify differnt parameters.  These paramters are outlined here:
```
	LogMessage
	LogMessage, EventID
	LogMessage, EntryType
	LogMessage, EntryType, EventID
```
I have include some examples below on using these different paramters and overload methods for each of the logging types (not all are listed).

```
$EventViewerLogging.Info('Logging to Some LogSource as informational text')
$EventViewerLogging.Success('Logging to Some LogSource as success text', '1001')
$EventViewerLogging.Success('Logging to Some LogSource as success text', 'Success')
$EventViewerLogging.Success('Logging to Some LogSource as success text', 'Warning')
$EventViewerLogging.Debug('Logging to Some LogSource as debug text', 'Debug', '1003')

```

If you are wanting to log errors specifically, then you have some additional overload methods available to you.  ALL overload methods/definitions are listed here for convience:
```
	ErrorMessage
	ErrorMessage, EventID
	ErrorMessage, EntryType
	ErrorMessage, EntryType, EventID
	ErrorMessage, ErrorRecord
	ErrorMessage, ErrorRecord, EventID
	ErrorMessage, ErrorRecord, EntryType
	ErrorMessage, ErrorRecord, EntryType, EventID
```
## EXAMPLE of using $EventViewerLogging with Error Records

```
try { 
   do-something 
} catch { 
   $EventViewerLogging.Error(''This is an error log event', $Error[0]) 
}
```
    Output in the Event Viewer
```
20170401T055444 [ERROR]: This is an error log event
20170401T055444 [ERROR]: The term 'do-something' is not recognized as the name of a cmdlet, `
                         function, script file, or operable program. Check the spelling of the name, `
                         or if a path was included, verify that the path is correct and try again. `
                         (CommandNotFoundException: :1 char:7)
```

## NOTES
   Name: Write-LogEntry
   Created by: Josh Rickard
   Created Date: 04/01/2017
## FUNCTIONALITY
   Write-LogEntry is a PowerShell helper function that will accept or create a log file and
   add strings based on severity, as well as parse $error[0] records for easy interpretation
   and readability.