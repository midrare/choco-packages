$packageDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$repoOwner = "VUE"
$repoName = "VUE"
$fileName = "VUE_Installer.zip"


function global:au_BeforeUpdate() {
    Get-RemoteFiles -Purge -NoSuffix
}

function global:au_GetLatest {
    $latest = Get-GitHubRelease -OwnerName $repoOwner -RepositoryName $repoName -Latest
    $version = $latest.published_at.ToString("0.yyyyMMdd")

    $url64 = $latest.assets | ? { $_.name -Match $fileName } | Select -First 1 | Select -Expand browser_download_url

    return @{ Version = $version; URL64 = $url64; }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyinstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
            "(^[$]url64\s*=\s*)('.*')" = "`$1'$($Latest.URL64)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        };
    }
}


# SNIP POWERSHELL_FOR_GITHUB last modified: 2024-09-07
if (-not (Get-Module -ListAvailable -Name "PowerShellForGitHub")) {
    Write-Host "The required PowerShell module ""PowerShellForGitHub"" is not installed. Installing..."
    Install-Module -Name "PowerShellForGitHub" -Force
    if (-not (Get-Module -ListAvailable -Name "PowerShellForGitHub")) {
        throw "Failed to install the required PowerShell module ""PowerShellForGitHub""."
    }
}


Push-Location $packageDir
# need `-ChecksumFor none` when using au_BeforeUpdate() to prevent file not found caused by hashing non-existent file
Update-Package -ChecksumFor none
Pop-Location

