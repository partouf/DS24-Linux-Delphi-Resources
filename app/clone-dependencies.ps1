$ErrorActionPreference = "Stop"

New-Item -Type Directory "dmvcframework"

Invoke-WebRequest -Uri "https://github.com/danieleteti/delphimvcframework/releases/download/v3.4.1-sodium/dmvcframework-3.4.1-sodium.zip" -OutFile "dmvcframework.zip"

Expand-Archive -Path "dmvcframework.zip" -DestinationPath "./dmvcframework"

Remove-Item "dmvcframework.zip"
