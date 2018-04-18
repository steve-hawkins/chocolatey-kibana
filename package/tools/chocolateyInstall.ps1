$kibana_version = $env:ChocolateyPackageVersion

$tools_dir = Split-Path -Path $MyInvocation.MyCommand.Definition

Install-ChocolateyZipPackage -PackageName 'kibana' `
  -Url "https://artifacts.elastic.co/downloads/kibana/kibana-$($kibana_version)-windows-x86_64.zip" `
  -UnzipLocation $tools_dir

$kibana_dir = "$($tools_dir)\kibana-$($kibana_version)-windows-x86_64"

Get-ChildItem `
  $kibana_dir `
  -Include *.exe `
  -Recurse `
  | ForEach-Object {New-Item "$($_.FullName).ignore" -Type File -Force} `
  | Out-Null

$nssm_exe = "$($env:ChocolateyInstall)\bin\nssm.exe"

if (Get-Service -Name 'elastic-kibana' -ErrorAction SilentlyContinue) {
  Stop-Service -Name 'elastic-kibana'

  Start-ChocolateyProcessAsAdmin `
    -Statements "remove elastic-kibana confirm" `
    -ExeToRun $nssm_exe
}

Start-ChocolateyProcessAsAdmin `
  -Statements "install elastic-kibana $($kibana_dir)\bin\kibana.bat" `
  -ExeToRun $nssm_exe

Set-Service -Name 'elastic-kibana' `
  -DisplayName "Elastic Kibana $($kibana_version)" `
  -Description 'Your window into the Elastic stack.' `
  -StartupType Manual
