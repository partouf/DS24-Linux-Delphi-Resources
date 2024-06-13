Param(
	[String] $RepoDirMain
)

cd $RepoDirMain
$commitHashMain = (git rev-parse HEAD)

$data = "`r`nconst C_COMMITHASH_MAIN: string = '$commitHashMain';`r`n"

$filepath = Join-Path -Path $RepoDirMain -ChildPath "version.inc"
Set-Content -Path $filepath -Value $data
