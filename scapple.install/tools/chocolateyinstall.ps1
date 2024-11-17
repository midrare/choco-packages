$ErrorActionPreference = 'Stop'
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = ''
$url64          = 'https://www.literatureandlatte.com/scappleforwindows/downloads/Scapple-1420-installer.exe'
$checksum       = ''
$checksumType   = ''
$checksum64     = '2653a905e7c975c243ee3942acd900918b13876e14b0fc4c7d7e5f574a39221e'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url
  url64bit       = $url64

  softwareName   = 'Scapple'

  checksum       = $checksum
  checksumType   = $checksumType
  checksum64     = $checksum64
  checksumType64 = $checksumType64

  silentArgs     = '--mode unattended'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

# do not shim anything by default
Get-ChildItem $toolsDir -Include *.exe -Recurse | % { New-Item "$_.ignore" -Type file -Force | Out-Null }
