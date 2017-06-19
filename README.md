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

This Class can be used directly by loading the 'PSLogging.ps1' file in the 'Class' folder or by using one of the functions contained in the 'Public' folder.  
* [New-EventViewerClass](docs/New-EventViewerClass.md)
* [New-LogFileClass](docs/New-LogFileClass.md)
* [New-WriteHostClass](docs/New-WriteHostClass.md)



## Using PSLogging Class's directly
As mentioned previously, there are multiple classes contained within the PSLogging.ps1 file.  These are listed below, as well as their individual documentation pages:

* [EventViewer](docs/EventViewer.md)
* [LogFile](docs/LogFile.md)
* [WriteHost](docs/WriteHost.md)

## NOTES
   Name: Write-LogEntry
   Created by: Josh Rickard
   Created Date: 04/01/2017
## FUNCTIONALITY
   Write-LogEntry is a PowerShell helper function that will accept or create a log file and
   add strings based on severity, as well as parse $error[0] records for easy interpretation
   and readability.