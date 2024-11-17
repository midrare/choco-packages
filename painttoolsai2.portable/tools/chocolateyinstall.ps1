$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = 'https://www.systemax.jp/bin/sai2-20240814-32bit-en.zip'
$url64          = 'https://www.systemax.jp/bin/sai2-20240814-64bit-en.zip'
$checksum       = 'b91bf49357673caa3b33a7cce95bee2320e671c739ffe27bf7a1ee5ce40ebc73'
$checksumType   = 'sha256'
$checksum64     = 'beaf825ac3309c01c5532b4a562e139aedbcbd73e6efa5f60e4374988ff7fe9a'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = Join-Path $toolsDir "sai2"

  url            = $url
  url64bit       = $url64

  file           = Split-Path -Leaf $url
  file64         = Split-Path -Leaf $url64

  softwareName   = 'Paint Tool SAI 2'

  checksum       = $checksum
  checksumType   = $checksumType
  checksum64     = $checksum64
  checksumType64 = $checksumType64

  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyZipPackage @packageArgs
Copy-Item -Path (Join-Path $toolsDir "icon.ico") -Destination $packageArgs.unzipLocation -Force


# make start menu shortcut
Get-ChildItem $packageArgs.unzipLocation -Include "sai2.exe" -Recurse | % {
  Install-ChocolateyShortcut `
    -ShortcutFilePath "$env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\Paint Tool SAI 2 (Portable).lnk" `
    -TargetPath $_ `
    -IconLocation (Join-Path $packageArgs.unzipLocation "icon.ico") `
    -Description "Hierarchical spreadsheet app"
}


# do not shim anything by default
Get-ChildItem $toolsDir -Include *.exe -Recurse | % { New-Item "$_.ignore" -Type file -Force | Out-Null }
