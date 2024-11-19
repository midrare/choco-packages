#Requires -Version 5

$packageDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$releasesUrl = "https://www.systemax.jp/en/sai/devdept.html"
$releasesUri = [System.Uri]::new($releasesUrl)
$scheme = $releasesUri.Scheme
$baseUrl = $releasesUri.GetLeftPart([System.UriPartial]::Authority)


function global:au_GetLatest {
    $request = Invoke-WebRequest -Uri $releasesUrl -UseBasicParsing
    $html = New-Object -Com HTMLFile
    [string]$htmlBody = $request.Content
    $html.write([ref]$htmlBody)

    $a64 = $html.getElementsByTagName("a") | ? innerText -match "SAI2 64bit" | Select -First 1
    If (-not $a64) {
        throw "Failed to find HTML element for 64-bit release."
    }

    $a32 = $html.getElementsByTagName("a") | ? innerText -match "SAI2 32bit" | Select -First 1
    If (-not $a32) {
        throw "Failed to find HTML element for 32-bit release."
    }

    $url64 = $a64.href -replace "^about://", "${scheme}://" -replace "^about:/","${baseUrl}/"
    $url32 = $a32.href -replace "^about://", "${scheme}://" -replace "^about:/","${baseUrl}/"

    $version64 = $null
    If ($a64.innerText -match "SAI2 [0-9]+bit - ([0-9]{4}-[0-9]{2}-[0-9]{2}) ") {
        $version64 = "0.0.0." + ($matches[1] -replace "[^0-9]+","")
    }
    If (-not $version64) {
        throw "Failed to extract version string from `"$a64.innerText`"."
    }

    $version32 = $null
    If ($a32.innerText -match "SAI2 [0-9]+bit - ([0-9]{4}-[0-9]{2}-[0-9]{2}) ") {
        $version32 = "0.0.0." + ($matches[1] -replace "[^0-9]+","")
    }
    If (-not $version32) {
        throw "Failed to extract version string from `"$a32.innerText`"."
    }

    If ($version64 -ne $version32) {
        throw ("Version mismatch between different bitness"`
            + " (x86: $version32 vs. x64: $version64)")
    }

    # TODO Remove -alpha suffix when SAI2 final is released
    $version32 += "-alpha"
    $version64 += "-alpha"

    return @{ Version = $version64; URL32 = $url32; URL64 = $url64 }
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
        "tools\chocolateyuninstall.ps1" = @{
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
    }
}


Push-Location $packageDir
Update-Package
Pop-Location


# vim:tw=78:ts=4:
