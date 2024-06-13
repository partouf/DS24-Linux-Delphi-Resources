$ErrorActionPreference = "Stop"

$DccRoot = "C:/dcc"
$Dcc21 = "$DccRoot/21.0/bin/dcclinux64.exe"
$LibPath = "$DccRoot/21.0/lib/linux64/release"

$Sdks = "C:/dcc/SDKs"
$Ub22Sdk = "$Sdks/ubuntu22.04.sdk"

New-Item -Path "./dcu" -ItemType Directory

& $Dcc21 -B "-O$LibPath" "--libpath:$Ub22Sdk/lib64" "--libpath:$Ub22Sdk/usr/lib/gcc/x86_64-linux-gnu/11" "--syslibroot:$Ub22Sdk" "-NU./dcu" "-U$LibPath" "-U./dmvcframework/sources" "-I./dmvcframework/sources" "-U./dmvcframework/lib/loggerpro" "-U./dmvcframework/lib/swagdoc/Source" ds24_app.dpr

exit $LASTEXITCODE
