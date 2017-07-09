enum EntryType
{
    Error
    Warning
    Information
    SuccessAudit
    FailureAudit
}

enum EventId
{
    Error = 1001
    Warning = 1002
    Information = 1003
    SuccessAudit =  1004
    FailureAudit = 1005
}

class Log 
{

    [Boolean]
    $WriteHost = $false
    
    [Boolean]
    $EventViewer = $false

    [string] Info([String] $msg)
    {
        $info = "$((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss')) [INFO]: $msg"
        return $info
    }

    [string] Success([String] $msg) 
    {
        $Success = "$((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss')) [SUCCESS]: $msg"
        return $Success
    }

    [string] Warning([String] $msg)
    {
        $Warning = "$((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss')) [WARNING]: $msg"
        return $Warning
    }

    [string] Debug([String] $msg)
    {
        $Debug = "$((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss')) [DEBUG]: $msg"
        return $Debug
    }

    [string] Error([String] $msg)
    {
        $Error = "$((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss')) [ERROR]: $msg"
        return $Error
    }

    [string] Error([System.Management.Automation.ErrorRecord] $ErrorRecord)
    {
        $ErrorMessage = '{0} {1} ({2}: {3}:{4} char:{5})' -f "$((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss')) [ERROR_RECORD]",
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
    [string]$CategoryResourceFile
    [string]$MessageResourceFile
    [string]$ParameterResourceFile
    [string[]]$ComputerName
    [EntryType]$EntryType
    [EventId]$EventId
 
    EventViewer([string]$LogName, [string]$LogSource)
    {
        $this.LogName   = $LogName
        $this.LogSource = $LogSource

        if([System.Diagnostics.EventLog]::Exists($LogSource))
        {
            $params = @{
                LogName               = $this.LogName
                Source                = $this.LogSource
            }
        
            New-EventLog @params
        }
        else
        {
            Write-Warning -Message "The LogSource of $LogSource already exists"
        }
    }

    EventViewer([string]$LogName, [string]$LogSource, [boolean]$ResourceFile)
    {
        if([System.Diagnostics.EventLog]::Exists($LogSource))
        {
            $params = @{
                LogName               = $LogName
                Source                = $LogSource
            }

            if ($ResourceFile)
            {
                $ResourceReturn = $this.CheckResourceFileIsSet()
                $params.Add($ResourceReturn)
            }
        
            New-EventLog @params
        }
        else
        {
            Write-Warning -Message "The LogSource of $LogSource already exists"
        }
    }

    EventViewer([string]$LogName, [string]$LogSource, [string[]]$ComputerName)
    {
        if([System.Diagnostics.EventLog]::Exists($LogSource))
        {
            $params = @{
                LogName               = $LogName
                Source                = $LogSource
                ComputerName          = $ComputerName
            }
        
            New-EventLog @params
        }
        else
        {
            Write-Warning -Message "The LogSource of $LogSource already exists"
        }
    }

    [System.Management.Automation.PSCustomObject] CheckResourceFileIsSet()
    {
        $param = New-Object -TypeName PSCustomObject

        if ($this.CategoryResourceFile)
        {
            $param | Add-Member –MemberType NoteProperty –Name CategoryResourceFile –Value $($this.CategoryResourceFile)
        }

        if ($this.MessageResourceFile)
        {
            $param | Add-Member –MemberType NoteProperty –Name MessageResourceFile –Value $($this.MessageResourceFile)
        }

        if ($this.ParameterResourceFile)
        {
            $param | Add-Member –MemberType NoteProperty –Name ParameterResourceFile –Value $($this.ParameterResourceFile)
        }

        return $param
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
        return $this.EventId -as [int]
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
        $this.SetEntryType('Information')
        $Message = ([Log]$this).Info($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Info([String] $msg,[EventId]$EventId)
    {
        $this.SetEntryType('Information')
        $this.SetEventID($EventId)
        
        $Message = ([Log]$this).Info($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Info([String] $msg, [EntryType]$EntryType)
    {
        $this.SetEntryType($EntryType)

        $Message = ([Log]$this).Info($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Info([String] $msg, [EntryType]$EntryType,[EventID]$EventID)
    {
        $this.SetEventID($EventID)
        $this.SetEntryType($EntryType)

        $Message = ([Log]$this).Info($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Success([String] $msg)
    {
        $this.SetEntryType('SuccessAudit')
        $Message = ([Log]$this).Success($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Success([String] $msg,[EventId]$EventId)
    {
        $this.SetEntryType('SuccessAudit')
        $this.SetEventID($EventId)
        
        $Message = ([Log]$this).Success($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Success([String] $msg, [EntryType]$EntryType)
    {
        $this.SetEntryType($EntryType)

        $Message = ([Log]$this).Success($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Success([String] $msg, [EntryType]$EntryType,[EventID]$EventID)
    {
        $this.SetEventID($EventID)
        $this.SetEntryType($EntryType)

        $Message = ([Log]$this).Success($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Warning([String] $msg)
    {
        $this.SetEntryType('Warning')

        $Message = ([Log]$this).Warning($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Warning([String] $msg,[EventId]$EventId)
    {
        $this.SetEntryType('Warning')
        $this.SetEventID($EventId)
        
        $Message = ([Log]$this).Warning($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Warning([String] $msg, [EntryType]$EntryType)
    {
        $this.SetEntryType($EntryType)

        $Message = ([Log]$this).Warning($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Warning([String] $msg, [EntryType]$EntryType,[EventID]$EventID)
    {
        $this.SetEventID($EventID)
        $this.SetEntryType($EntryType)

        $Message = ([Log]$this).Warning($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Debug([String] $msg)
    {
        $this.SetEntryType('Information')
        $Message = ([Log]$this).Debug($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Debug([String] $msg,[EventId]$EventId)
    {
        $this.SetEntryType('Information')
        $this.SetEventID($EventId)
        
        $Message = ([Log]$this).Debug($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Debug([String] $msg, [EntryType]$EntryType)
    {
        $this.SetEntryType($EntryType)

        $Message = ([Log]$this).Debug($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Debug([String] $msg, [EntryType]$EntryType,[EventID]$EventID)
    {
        $this.SetEventID($EventID)
        $this.SetEntryType($EntryType)

        $Message = ([Log]$this).Debug($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Error([String] $msg)
    {
        $this.SetEntryType('Error')
        $Message = ([Log]$this).Error($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Error([String] $msg,[EventId]$EventId)
    {
        $this.SetEntryType('Error')
        $this.SetEventID($EventId)
        
        $Message = ([Log]$this).Error($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Error([String] $msg, [EntryType]$EntryType)
    {
        $this.SetEntryType($EntryType)

        $Message = ([Log]$this).Error($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Error([String] $msg, [EntryType]$EntryType,[EventID]$EventID)
    {
        $this.SetEventID($EventID)
        $this.SetEntryType($EntryType)

        $Message = ([Log]$this).Error($msg)
        $this.WriteToEventLog($Message)
    }

    [void] Error([String] $msg, [System.Management.Automation.ErrorRecord] $ErrorRecord)
    {
        $this.SetEntryType('Error')

        $Message = ([Log]$this).Error($msg)
        $Message += ([Log]$this).Error($ErrorRecord)
        $this.WriteToEventLog($Message)
    }

    [void] Error([String] $msg,[System.Management.Automation.ErrorRecord] $ErrorRecord, [EventId]$EventId)
    {
        $this.SetEntryType('Error')
        $this.SetEventID($EventId)
        
        $Message = ([Log]$this).Error($msg)
        $Message += ([Log]$this).Error($ErrorRecord)

        $this.WriteToEventLog($Message)
    }

    [void] Error([String] $msg, [System.Management.Automation.ErrorRecord] $ErrorRecord, [EntryType]$EntryType)
    {
        $this.SetEntryType($EntryType)

        $Message = ([Log]$this).Error($msg)
        $Message += ([Log]$this).Error($ErrorRecord)

        $this.WriteToEventLog($Message)
    }

    [void] Error([String] $msg, [System.Management.Automation.ErrorRecord] $ErrorRecord, [EntryType]$EntryType, [EventID]$EventID)
    {
        $this.SetEventID($EventID)
        $this.SetEntryType($EntryType)

        $Message = ([Log]$this).Error($msg)
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