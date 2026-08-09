param(
    [ValidateSet("CPD", "AssistRx", "Andel", "Apaly")]
    [string]$Client = "CPD",
    [ValidateSet("OneRx", "MultipleRx", "ExistingPatient")]
    [string]$Scenario = "OneRx",
    [ValidateSet("QA1", "QA2", "QA3")]
    [string]$EpostEnvironment = "QA3"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$env:EPOST_ENVIRONMENT = $EpostEnvironment
$testName = switch ($Scenario) {
    "OneRx" { "TC_RXCORE_001_NewPatient_OneRx_$Client" }
    "MultipleRx" { "TC_RXCORE_002_NewPatient_MultipleRx_$Client" }
    "ExistingPatient" { "TC_RXCORE_003_ExistingPatient_$Client" }
}

dotnet test "$root\EpostRxCoreAutomation.sln" --settings "$root\EpostRxCore.runsettings" --filter "Name=$testName"
