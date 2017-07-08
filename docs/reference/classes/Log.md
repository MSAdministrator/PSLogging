# Log

## SYNOPSIS
The Log class is the parent class to all other (child) classes.  **You should NOT need to use this class directly.** 

## DESCRIPTION
The Log class is the parent class to all other (child) classes.  **You should NOT need to use this class directly.** This class is used by all child classes to format and return the specific formatting for the log level requested.

You can view the formatting that this class provides below:

|**Log Level**  |**Formatting**    |
|:-------------:|:----------------:|
|Informational  |2017-04-01T15:54:44 [INFO]: Provided Informational Text|
|Success        |2017-04-01T15:54:44 [SUCCESS]: Provided Successfull Text|
|Warning        |2017-04-01T15:54:44 [WARNING]: Provided Warning Text|
|Debug          |2017-04-01T15:54:44 [DEBUG]: Provided Debugging Text|
|Error          |2017-04-01T15:54:44 [ERROR]: Provided Error Text|
|ErrorRecord    |2017-04-01T15:54:44 [ERROR]: The term 'do-something' is not recognized as the name of a cmdlet, `
                                              function, script file, or operable program. Check the spelling of the name, `
                                              or if a path was included, verify that the path is correct and try again. `
                                              (CommandNotFoundException: :1 char:7)|

## INPUTS

### None

## OUTPUTS

### None

## NOTES
### This Class is for internal use only

## RELATED LINKS

