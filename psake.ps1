# PSake makes variables declared here available in other scriptblocks
# Init some things
Properties {
    $ProjectRoot   = $env:BHProjectPath
    $ChocolateyPackages = @('nodejs','calibre')
    $NodeModules        = @('gitbook-cli','gitbook-summary')
    $Timestamp     = Get-date -uformat "%Y%m%d-%H%M%S"
    $ApiKey        = $env:APIKEY
    $CompilingFolder = "$env:BHProjectPath/compiled_docs"
    $OutputPdfPath   = "$ProjectRoot/$env:BHProjectName.pdf"
    $OutputSitePath  = "$ProjectRoot/public"
}

Task Default -Depends InstallPrerequisites

Task InstallChocolatey {
    # Install Chocolatey
    If (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        # Check to see if admin; if not, this will fail!
        If (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
            Write-Error "Chocolatey is not installed; Administrator permissions are required to install chocolatey`r`nPlease elevate your permissions and try again."
        } Else {
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        }
    }
}

Task InstallChocolateyPackages -depends InstallChocolatey {
    # Install needed chocolatey packages
    ForEach ($Package in $ChocolateyPackages) {
        If (!(choco list --local-only | Where-Object {$_ -Match "^${Package}\s"})) {
            If (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
                Write-Error "Administrator permissions are required to install chocolatey packages`r`nPlease elevate your permissions and try again."
            } Else {
                choco install $Package -y
            }
        }
    }
    # Update the Path Variables
    Import-Module C:\ProgramData\chocolatey\helpers\chocolateyProfile.psm1
    Update-SessionEnvironment
}

Task InstallNodePackages -depends InstallChocolateyPackages {
    If (Get-Command npm -ErrorAction SilentlyContinue) {
        $GloballyInstalledModules = (npm ls --global --json | convertfrom-json).Dependencies
        ForEach ($Module in $NodeModules) {
            If ([string]::IsNullOrEmpty($GloballyInstalledModules."$Module")) {
                npm install -g $module
            }
        }
    } Else {Write-Warning "NPM not found; node modules not installed!"}
}

Task InstallPrerequisites -depends InstallNodePackages

Task Clean {
    If (Test-Path $CompilingFolder) {
        Remove-Item $CompilingFolder -Recurse -Force
    }
    If (Test-Path $OutputSitePath) {
        Remove-Item $OutputSitePath -Recurse -Force
    }
    If (Test-Path $OutputPdfPath) {
        Remove-Item $OutputPdfPath
    }
}

Task Compile -depends Clean {
    $null = mkdir $CompilingFolder
    Copy-Item -Path $ProjectRoot/*.md -Destination $CompilingFolder -Force
    Copy-Item -Path $ProjectRoot/docs/* -Destination $CompilingFolder -Recurse -Force
    If (Test-Path $ProjectRoot/media) {
        Copy-Item -Path $ProjectRoot/media -Destination $CompilingFolder -Recurse -Container -Force
    }
    Push-Location -Path $CompilingFolder
    book sm
    gitbook install
    Pop-Location
}

Task GenerateSite -depends Compile {
    gitbook build $CompilingFolder $OutputSitePath
}

Task GeneratePdf -depends Compile {
    gitbook pdf $CompilingFolder $OutputPdfPath
}

Task LivePreview -depends Compile {
    Push-Location -Path $CompilingFolder
    gitbook serve
    Pop-Location
}
