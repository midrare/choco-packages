$packageDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$repoOwner = "aardappel"
$repoName = "treesheets"
$fileName = "windows_treesheets_setup.exe"


function global:au_BeforeUpdate() {
    Get-RemoteFiles -Purge -NoSuffix
}

function global:au_GetLatest {
    $latest = Get-GitHubRelease -OwnerName $repoOwner -RepositoryName $repoName -Latest
    If (-not $latest) {
        throw "Failed to fetch latest release from $repoOwner/$repoName."
    }

    $version = $latest.published_at.ToString("0.yyyyMMdd")
    If (-not $version -or -not [Version]::Parse($version)) {
        throw "Failed to parse version string `"$version`"."
    }

    $url64 = $latest.assets | ? { $_.name -Match $fileName } | Select -First 1 | Select -Expand browser_download_url
    If (-not $url64) {
        throw "Failed to find `"$fileName`" in $repoOwner/$repoName assets."
    }

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


Push-Location $packageDir
# need `-ChecksumFor none` when using au_BeforeUpdate() to prevent file not found caused by hashing non-existent file
Update-Package -ChecksumFor none
Pop-Location

