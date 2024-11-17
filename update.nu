#!/usr/bin/env nu

cd $env.FILE_PWD
ls **/*.nuspec | get name | path dirname | each {|pkgdir|
    echo $pkgdir
    pwsh $"($pkgdir)/Update.ps1"
}
