# LogFile

## SYNOPSIS
To use the LogFile Class you need to either call the New-LogFileClass.ps1 or by loading the entire PSLogging class in the 'Class' folder.  

### New-LogFileClass

```powershell
$LogFileLogging = New-LogFileClass -LogFile 'C:\path\to\log\file\log.log'
$LogFileLogging = New-LogFileClass -LogFile 'C:\path\to\log\file\log.txt'
```

## SYNTAX

```powershell
$LogFileLogging = [LogFile]::new('C:\path\to\log\file\log.log')
$LogFileLogging = [LogFile]::new('C:\path\to\log\file\log.txt')
```

## DESCRIPTION
The LogFile Class has a single property that can be set.  This is the location or path to the log file you want to either create or use when logging.  After creating your new variable ($LogFileClass) you can use it to log information to a specified log file.  All sub-classes have a log 'level' that you can use when logging:

```
Informational (Info)
Success (Success)
Warning (Warning)
Debugging (Debug)
Error (Error)
Error (Error & ErrorRecord)
```

I have include some examples below on using these methods for each of the logging types.

```powershell
# Using the built-in New-LogFileClass function
$LogFile = New-LogFileClass -LogFile 'C:\path\to\log\file\log.log'
$LogFile = New-LogFileClass -LogFile 'C:\path\to\log\file\log.txt' 

# Using the [LogFile] Class object directly
$LogFileClass = [LogFile]::new('C:\some\path\to\log\file.log')
$LogFileClass.Info('some informational text')
$LogFileClass.Success('some success text')
$LogFileClass.Debug('some debug text')
$LogFileClass.Warning('some warning text')
$LogFileClass.Error('some error text')
$LogFileClass.Error('some error text', $error[0]) 

```
### EXAMPLE of using $LogFileClass with Error Records

```powershell
try { 
   do-something 
} catch { 
   $LogFileClass.Error('An error occured', $error[0])  
}
```

Output in the specified Log File

```text
2017-04-01T15:54:44 [ERROR]: An error occured
2017-04-01T15:54:44 [ERROR]: The term 'do-something' is not recognized as the name of a cmdlet, `
                             function, script file, or operable program. Check the spelling of the name, `
                             or if a path was included, verify that the path is correct and try again. `
                             (CommandNotFoundException: :1 char:7)
```

## EXAMPLES

### Example 1
```
C:\PS> $LogFile = New-LogFileClass -LogFile 'C:\path\to\log\file\log.log'
```

By calling the New-LogFileClass function directly, it will return a [LogFile] data type that can now be used to log to

## PARAMETERS

### -LogFile
Add location to create or use Log File

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True
Accept wildcard characters: False
```

## INPUTS

### System.String
### Pass in a string value for the path to create a LogFile

## OUTPUTS

### [LogFile]

## NOTES
### This function returns a [LogFile] object

## RELATED LINKS

