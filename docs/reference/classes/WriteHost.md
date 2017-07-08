# WriteHost

## SYNOPSIS
To use the [WriteHost] Class you need to either call the New-WriteHostClass.ps1 or by loading the entire PSLogging class in the 'Class' folder.  

### WriteHostClass

```powershell
$WriteHostLogging = New-WriteHostClass
```

## SYNTAX

```powershell
$WriteHostLogging = [WriteHost]::new()
```

## DESCRIPTION
The WriteHost Class has no overload defitions, but you can change the default properties (output colors) depending on your own preferences. After creating your new variable ($WriteHostLogging) you can use it to log information to the console. You have the same log levels as you do with all of the classes in this module:

```
Informational (Info)
Success (Success)
Warning (Warning)
Debugging (Debug)
Error (Error)
Error (Error & ErrorRecord)
```

Outlined below is the default colors associated with each log level in the WriteHost class:
```
|**Log Level**|**Class Property**|**Color**|
|:-----------:|:----------------:|:-------:|
|Informational|InfoColor         |Cyan     |
|Success      |ErrorColor        |Green    |
|Warning      |WarningColor      |Yellow   |
|Debug        |DebugColor        |Yellow   |
|Error        |ErrorColor        |Red      |
```
You can change the specified color you would like to output with by following the examples below:
```
$WriteHostLogging = [WriteHost]::new()
$WriteHostLogging.Info('Information text to written to console in cyan')
$writeHostLogging.InfoColor = 'Red'
$WriteHostLogging.Info('Information text to written to console in Red')
```

I have include some examples below on using these different log levels for each of the logging types.

```powershell
$WriteHostClass = [WriteHost]::new()
$WriteHostClass.Info('some informational text')
$WriteHostClass.Success('some success text')
$WriteHostClass.Debug('some debug text')
$WriteHostClass.Warning('some warning text')
$WriteHostClass.Error('some error text')
$WriteHostClass.Error('some error text', $error[0]) 
```

### EXAMPLE of using $WriteHostClass with Error Records

```powershell
try { 
   do-something 
} catch { 
   $WriteHostClass.Error(''This is an error event', $Error[0]) 
}
```

Output in the console

```text
2017-04-01T15:54:44 [ERROR]: This is an error event
2017-04-01T15:54:44 [ERROR]: The term 'do-something' is not recognized as the name of a cmdlet, `
                             function, script file, or operable program. Check the spelling of the name, `
                             or if a path was included, verify that the path is correct and try again. `
                             (CommandNotFoundException: :1 char:7)
```

## EXAMPLES

### Example 1
```
C:\PS> $WriteHostLogging = New-WriteHostClass
```

By calling the New-EventViewerClass function, it will return a [WriteHost] data type that can now be used to log to the console

## PARAMETERS

```
# There are no parameters for this function

## INPUTS

### None

## OUTPUTS

### [WriteHost]

## NOTES
### This function returns a [WriteHost] object

## RELATED LINKS

