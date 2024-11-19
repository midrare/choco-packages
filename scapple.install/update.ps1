#Requires -Version 7

$packageDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$releasesUrl = ("https://www.literatureandlatte.com/" `
    + "scapple/release-notes?os=Windows")
$templateUrl = ("https://www.literatureandlatte.com/" `
    + "scappleforwindows/downloads/Scapple-NNNN-installer.exe")

function global:au_GetLatest {
    $request = Invoke-WebRequest -Uri $releasesUrl -UseBasicParsing
    $html = New-Object -Com HTMLFile
    [string]$htmlBody = $request.Content
    $html.write([ref]$htmlBody)

    $latest = $html.getElementsByClassName("accordion") | ? {
        $_.getElementsByTagName("download-icon-text").Count -gt 0
    } | Select -First 1
    If (-not $latest) {
        throw "Failed to find HTML element containing latest release."
    }

    $title = $latest.getElementsByClassName("accordion-title") `
        | Select -First 1 -Expand innerText
    $date = $latest.getElementsByClassName("accordion-date") `
        | Select -First 1 -Expand innerText
    $version = $title.Substring(0, $title.Length - $date.Length) `
        | Select-String -Pattern "(?<=[^\s]+\s+)([0-9]\S*)" `
        | Select -Expand Matches `
        | Select -Expand Value
    If (-not $version) {
        throw "Failed to find HTML element containing version string."
    }

    $relnotes = ($latest.getElementsByTagName("li") `
        | Select -Expand innerText) -Split "^\r?\n", 0, "multiline" `
        | % { $_.Trim() } `
        | Select-String -Pattern '^\s*$' -NotMatch
    If (-not $relnotes) {
        throw "Failed to find HTML element containing release notes."
    }

    $url64 = $latest.getElementsByClassName("download-icon-text") `
        | Select -First 1 -Expand href
    If (-not $url64) {
        throw "Failed to find download link in HTML."
    }


    $relnotes = (
        "<![CDATA[<ul>" `
        + (($relnotes | % { "<li>$_</li>" }) -Join '') `
        + "</ul>]]>"
    )

    [version]$verobj = $version
    $vermaj = (($verobj.Major, 0 | Measure -Max).Maximum)
    $vermin = (($verobj.Minor, 0 | Measure -Max).Maximum)
    $verbld = (($verobj.Build, 0 | Measure -Max).Maximum)
    $verrev = (($verobj.Revision, 0 | Measure -Max).Maximum)
    $url64 = $templateUrl `
        -Replace "NNNN","$($vermaj)$($vermin)$($verbld)$($verrev)"

    return @{ Version = $version; URL64 = $url64; ReleaseNotes = $relnotes }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyinstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')" = `
                "`$1'$($Latest.URL32)'"
            "(^[$]url64\s*=\s*)('.*')" = `
                "`$1'$($Latest.URL64)'"
            "(^[$]checksum\s*=\s*)('.*')" = `
                "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = `
                "`$1'$($Latest.ChecksumType32)'"
            "(^[$]checksum64\s*=\s*)('.*')" = `
                "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType64\s*=\s*)('.*')" = `
                "`$1'$($Latest.ChecksumType64)'"
        };
        "scapple.install.nuspec" = @{
            '(<releaseNotes>)(.*)(</releaseNotes>)' = `
                "`$1$($Latest.ReleaseNotes)`$3"
        }
    }
}


Push-Location $packageDir
# need `-ChecksumFor 64` to prevent choco from thinking 32-bit is supported
Update-Package -ChecksumFor 64
Pop-Location


# vim:tw=78:ts=4:
