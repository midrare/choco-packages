$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = ''
$url64          = 'https://github.com/aardappel/treesheets/releases/download/11846384060/windows_treesheets_setup.exe'
$checksum       = ''
$checksumType   = ''
$checksum64     = '68487DB115F79517E78DCBE39F3F05FB7E12C535F28CEABCF33B8CD0981573B5'
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
