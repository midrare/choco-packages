$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = ''
$url64          = 'https://github.com/aardappel/treesheets/releases/download/11899533196/windows_treesheets_setup.exe'
$checksum       = ''
$checksumType   = ''
$checksum64     = '91A231CEE75A710A253F136F033F82331A1A514D15BBC948B824BCA391FCB529'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir

  file          = Join-Path $toolsDir "windows_treesheets_setup.exe"
  fileType      = "exe"
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


Install-ChocolateyInstallPackage @packageArgs

# do not shim anything by default
Get-ChildItem $toolsDir -Include *.exe -Recurse | % { New-Item "$_.ignore" -Type file -Force | Out-Null }
