$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = ''
$url64          = 'https://github.com/aardappel/treesheets/releases/download/11899533196/windows_treesheets_no_installer.zip'
$checksum       = ''
$checksumType   = ''
$checksum64     = '856726BB8D62C3A517F454E89AB9F942057128E43AB98CA962AD63A5347FB838'
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
