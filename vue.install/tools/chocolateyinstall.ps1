$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = ''
$url64          = 'https://github.com/VUE/VUE/releases/download/3.3.0/VUE_Installer.zip'
$checksum       = ''
$checksumType   = ''
$checksum64     = '248FEB78597BC9BE59C19FAC047B126E5FFF6EEF72240BB8E613BDBE31764851'
$checksumType64 = 'sha256'
$fileZip        = Join-Path $toolsDir "VUE_Installer.zip"
$file           = Join-Path $toolsDir "vue-installer.exe"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir

  file          = $file
  fileType      = 'exe'
  url           = $url
  url64bit      = $url64

  softwareName  = 'VUE'

  checksum      = $checksum
  checksumType  = $checksumType
  checksum64    = $checksum64
  checksumType64= $checksumType64

  silentArgs    = '/SP- /VERYSILENT /SUPPRESSMSGBOXES'
  validExitCodes= @(0)
}


Get-ChocolateyUnzip -FileFullPath $fileZip -Destination $toolsDir
Install-ChocolateyInstallPackage @packageArgs

# do not shim anything by default
Get-ChildItem $toolsDir -Include *.exe -Recurse | % { New-Item "$_.ignore" -Type file -Force | Out-Null }
