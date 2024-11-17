$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'TreeSheets'
  fileType      = "zip"
  zipFileName   = "windows_treesheets_no_installer.zip"
  silentArgs    = '/S'
  validExitCodes= @(0)
}


Uninstall-ChocolateyZipPackage @packageArgs
Remove-Item -Force -Path `
  "$env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\TreeSheets (Portable).lnk"

