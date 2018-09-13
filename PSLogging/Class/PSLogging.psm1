enum EntryType
{
    Error = 1
    Warning = 2
    Information = 4
    SuccessAudit = 8
    FailureAudit = 16
}

enum EventId
{
    Error = 1001
    Warning = 1002
    Information = 1003
    SuccessAudit =  1004
    FailureAudit = 1005
}

Class DateTimeValidation 
{
    static [string] $DateTimePattern

    static [bool] validateDateTimePatterns([string]$Pattern)
    {
        $TimePatterns = [System.Globalization.DateTimeFormatInfo]::CurrentInfo

        foreach ($item in $TimePatterns.GetAllDateTimePatterns())
        {
            if ($Pattern -eq $item)
            {
                [DateTimeValidation]::DateTimePattern = $Pattern
                return $true
            }
        }
        return $false
    }
}


class Log 
{

    [Boolean]
    $WriteHost = $false
    
    [Boolean]
    $EventViewer = $false

    [string] Info([String] $msg)
    {
        $info = "$((Get-Date -Format o).ToString()) [INFO]: $msg"
        return $info
    }

    [string] Success([String] $msg) 
    {
        $Success = "$((Get-Date -Format o).ToString()) [SUCCESS]: $msg"
        return $Success
    }

    [string] Warning([String] $msg)
    {
        $Warning = "$((Get-Date -Format o).ToString()) [WARNING]: $msg"
        return $Warning
    }

    [string] Debug([String] $msg)
    {
        $Debug = "$((Get-Date -Format o).ToString()) [DEBUG]: $msg"
        return $Debug
    }

    [string] Error([String] $msg)
    {
        $Error = "$((Get-Date -Format o).ToString()) [ERROR]: $msg"
        return $Error
    }

    [string] Error([System.Management.Automation.ErrorRecord] $ErrorRecord)
    {
        $ErrorMessage = '{0} {1} ({2}: {3}:{4} char:{5})' -f "$((Get-Date -Format o).ToString()) [ERROR_RECORD]",
                                                             $ErrorRecord.Exception.Message,
                                                             $ErrorRecord.FullyQualifiedErrorId,
                                                             $ErrorRecord.InvocationInfo.ScriptName,
                                                             $ErrorRecord.InvocationInfo.ScriptLineNumber,
                                                             $ErrorRecord.InvocationInfo.OffsetInLine

        return $ErrorMessage
    }

    [System.Threading.Mutex] Mutex()
    {
        return $(New-Object -TypeName 'Threading.Mutex' -ArgumentList $false, 'MyInterprocMutex')
    }
}



class EventViewer : Log
{
    [string]$LogName
    [string]$LogSource
    [string[]]$ComputerName
    [EntryType]$EntryType
    [EventId]$EventId
 
    EventViewer([string]$LogName, [string]$LogSource)
    {
        $this.LogName   = $LogName
        $this.LogSource = $LogSource

        Write-Verbose -Message 'Setting EntryType & EventId to default state of Informational'

        $this.SetEntryType([EntryType]::Information)
        $this.SetEventID([EventId]::Information)

        if(!([System.Diagnostics.EventLog]::SourceExists($LogSource)))
        {
            $params = @{
                LogName               = $this.LogName
                Source                = $this.LogSource
            }
        
            New-EventLog @params
            Write-Information -MessageData "Writing to $LogSource"

        }
        else
        {
            Write-Warning -Message "The LogSource of $LogSource already exists"
            Write-Information -MessageData "Writing to $LogSource"
        }
    }

    EventViewer([string]$LogName, [string]$LogSource, [string[]]$ComputerName)
    {
        $this.LogName   = $LogName
        $this.LogSource = $LogSource

        if(!([System.Diagnostics.EventLog]::SourceExists($LogSource)))
        {
            $params = @{
                LogName               = $LogName
                Source                = $LogSource
                ComputerName          = $ComputerName
            }
        
            New-EventLog @params
            Write-Information -MessageData "Writing to $LogSource"
        }
        else
        {
            Write-Warning -Message "The LogSource of $LogSource already exists"
            Write-Information -MessageData "Writing to $LogSource"
        }
    }

    SetLogName([string]$LogName)
    {
        $this.LogName = $LogName
    }

    SetSourceName([string]$LogSource)
    {
        $this.LogSource = $LogSource
    }

    SetEventID([EventID]$EventID)
    {
        $this.EventId = $EventID
    }

    SetEntryType([EntryType]$EntryType)
    {
        $this.EntryType = $EntryType
    }

    [string] GetLogName()
    {
        return $this.LogName
    }

    [string] GetSourceName()
    {
        return $this.LogSource
    }

    [int] GetEventIDNumber()
    {
        return $this.EventId.value__ -as [int]
    }

    [string] GetEventIDName()
    {
        return $this.EventId
    }

    [string] GetEntryType()
    {
        return $this.EntryType
    }

    [void] Info([String] $msg)
    {
        #$this.SetEntryType('Information')
        $this.SetEntryType([EntryType]::Information)
        $this.SetEventID([EventId]::Information)

        $Message = ([Log]$this).Info($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Success([String] $msg)
    {
        $this.SetEntryType([EntryType]::SuccessAudit)
        $this.SetEventID([EventId]::SuccessAudit)

        $Message = ([Log]$this).Success($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Warning([String] $msg)
    {
        $this.SetEntryType([EntryType]::Warning)
        $this.SetEventID([EventId]::Warning)

        $Message = ([Log]$this).Warning($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Debug([String] $msg)
    {
        $this.SetEntryType([EntryType]::Information)
        $this.SetEventID([EventId]::Information)

        $Message = ([Log]$this).Debug($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Error([String] $msg)
    {
        $this.SetEntryType([EntryType]::Error)
        $this.SetEventID([EventId]::Error)

        $Message = ([Log]$this).Error($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Error([String] $msg, [System.Management.Automation.ErrorRecord] $ErrorRecord)
    {
        $this.SetEntryType([EntryType]::Error)
        $this.SetEventID([EventId]::Error)

        $Message = ([Log]$this).Error($msg) + "`r"
        $Message += ([Log]$this).Error($ErrorRecord)
        $this.WriteToEventLog($Message)
    }

    hidden [void] WriteToEventLog([string]$msg)
    {
        # Need to add logic for EventId enum and setting it to a default value
        
        $params = @{
            LogName   = $this.GetLogName()
            Source    = $this.GetSourceName()
            Message   = $msg
            EventId   = $this.GetEventIDNumber()
            EntryType = $this.GetEntryType()
        }
        Write-EventLog @params
    }
}

class LogFile : Log
{
    [System.String]
    $LogFile = "$($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(‘.\’))" + "\log.log"


    LogFile([string]$LogFile)
    {
        if (-not(Get-ChildItem -Path $LogFile)){
            try{
                New-Item -Path $LogFile -ItemType File -Force #-Confirm:$false
            }
            catch{
                Write-Error -ErrorRecord $Error[0] 
                    -RecommendedAction 'Unable to create log file.`n
                                        Please ensure you have access to create a log file in the provided location'
            }
        }

        $this.LogFile = $LogFile
    }

    [void] Info([String] $msg)
    {
        $Message = ([Log]$this).Info($msg)
        $this.AddContent($Message)
    }

    [void] Success([String] $msg) 
    {
        $Message = ([Log]$this).Success($msg)
        $this.AddContent($Message)
    }

    [void] Warning([String] $msg)
    {
        $Message = ([Log]$this).Warning($msg)
        $this.AddContent($Message)
    }

    [void] Debug([String] $msg)
    {
        $Message = ([Log]$this).Debug($msg)
        $this.AddContent($Message)
    }

    [void] Error([String]$msg)
    {
        $Message = ([Log]$this).Error($msg)
        $this.AddContent($Message)
    }

    [void] Error([String]$msg, [System.Management.Automation.ErrorRecord] $ErrorRecord)
    {
        $Message = ([Log]$this).Error($msg)
        $this.AddContent($Message)

        $ErrorMessage = ([Log]$this).Error($ErrorRecord)
        $this.AddContent($ErrorMessage)
    }

    hidden [void] AddContent([string]$msg)
    {
        $mutex = $this.Mutex()
        $mutex.Waitone() | Out-Null

        Add-Content -Path $this.LogFile -Value "$msg"

        $mutex.ReleaseMutex() | Out-Null
    }
}

class WriteHost : Log
{
    [string]$InfoColor = 'Cyan'
    [string]$ErrorColor = 'Red'
    [string]$SuccessColor = 'Green'
    [string]$WarningColor = 'Yellow'
    [string]$DebugColor = 'Yellow'

    setInfoColor([System.ConsoleColor]$Color)
    {
        $this.InfoColor = $Color
    }

    [string] getInfoColor()
    {
        return $this.InfoColor
    }
    
    setErrorColor([System.ConsoleColor]$Color)
    {
        $this.ErrorColor = $Color
    }

    [string] getErrorColor()
    {
        return $this.InfoColor
    }

    setSuccessColor([System.ConsoleColor]$Color)
    {
        $this.SuccessColor = $Color
    }

    [string] getSuccessColor()
    {
        return $this.SuccessColor
    }
    
    setWarningColor([System.ConsoleColor]$Color)
    {
        $this.WarningColor = $Color
    }

    [string] getWarningColor()
    {
        return $this.WarningColor
    }

    setDebugColor([System.ConsoleColor]$Color)
    {
        $this.DebugColor = $Color
    }

    [string] getDebugColor()
    {
        return $this.DebugColor
    }

    [void] Info([String] $msg)
    {
        $Message = ([Log]$this).Info($msg)
        Write-Host "$Message" -ForegroundColor $this.InfoColor
    }

    [void] Success([String] $msg) 
    {
        $Message = ([Log]$this).Success($msg)
        Write-Host "$Message" -ForegroundColor $this.SuccessColor
    }

    [void] Warning([String] $msg)
    {
        $Message = ([Log]$this).Warning($msg)
        Write-Host "$Message" -ForegroundColor $this.WarningColor
    }

    [void] Debug([String] $msg)
    {
        $Message = ([Log]$this).Debug($msg)
        Write-Host "$Message" -ForegroundColor $this.DebugColor
    }

    [void] Error([String]$msg)
    {
        $Message = ([Log]$this).Error($msg)
        Write-Host "$Message" -ForegroundColor $this.ErrorColor
    }

    [void] Error([String]$msg, [System.Management.Automation.ErrorRecord] $ErrorRecord)
    {
        $Message = ([Log]$this).Error($msg)
        Write-Host "$Message" -ForegroundColor $this.ErrorColor

        $ErrorMessage = ([Log]$this).Error($ErrorRecord)
        Write-Host "$ErrorMessage" -ForegroundColor $this.ErrorColor
    }
}