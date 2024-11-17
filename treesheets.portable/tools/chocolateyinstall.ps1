$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = ''
$url64          = 'https://github.com/aardappel/treesheets/releases/download/11846384060/windows_treesheets_no_installer.zip'
$checksum       = ''
$checksumType   = ''
$checksum64     = 'E57F05C5C3819F45EE880054B20CC50F39B2DCB78C5D9120405138234D3A4959'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir

  file          = Join-Path $toolsDir "windows_treesheets_no_installer.zip"
  fileType      = "zip"
  url           = $url
  url64bit      = $url64

  softwareName  = 'TreeSheets'

  checksum      = $checksum
  checksumType  = $checksumType
  checksum64    = $checksum64
  checksumType64= $checksumType64

  silentArgs   = '/S'
  validExitCodes= @(0)
}


Get-ChocolateyUnzip @packageArgs

# make start menu shortcut
Get-ChildItem $packageArgs.unzipLocation -Include "TreeSheets.exe" -Recurse | % {
  Install-ChocolateyShortcut `
    -ShortcutFilePath "$env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\TreeSheets (Portable).lnk" `
    -TargetPath $_ `
    -Description "Hierarchical spreadsheet app"
}


# do not shim anything by default
Get-ChildItem $toolsDir -Include *.exe -Recurse | % { New-Item "$_.ignore" -Type file -Force | Out-Null }
