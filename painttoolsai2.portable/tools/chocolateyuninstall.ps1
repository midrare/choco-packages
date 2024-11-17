$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = 'https://www.systemax.jp/bin/sai2-20240814-32bit-en.zip'
$url64          = 'https://www.systemax.jp/bin/sai2-20240814-64bit-en.zip'
$zipFileName   = Split-Path -Leaf $url
$zipFileName64 = Split-Path -Leaf $url64

Uninstall-ChocolateyZipPackage $env:ChocolateyPackageName $zipFileName
Uninstall-ChocolateyZipPackage $env:ChocolateyPackageName $zipFileName64

Remove-Item -Force -Path `
  "$env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\Paint Tool SAI 2 (Portable).lnk"

