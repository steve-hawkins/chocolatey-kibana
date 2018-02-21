if (Get-Service -Name 'elastic-kibana' -ErrorAction SilentlyContinue) {
  Stop-Service -Name 'elastic-kibana'

  $nssm_exe = "$($env:ChocolateyInstall)\bin\nssm.exe"

  Start-ChocolateyProcessAsAdmin `
    -Statements 'remove elastic-kibana confirm' `
    -ExeToRun $nssm_exe
}
