$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
dotnet test "$root\EpostRxCoreAutomation.sln" --settings "$root\EpostRxCore.runsettings" --filter "TestCategory=SelfTest"
