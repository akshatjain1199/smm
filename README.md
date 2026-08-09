# ePost RxCore Functional Automation

This is a beginner-friendly .NET 8, NUnit and Selenium framework for the complete Producer → RxCore → ePost functional flow. It is intentionally separate from regression automation and does not validate the database, EDI table, XML image, or developer-only event logs.

## What is automated

1. Generate a valid new patient, or reuse that exact patient for an existing-patient scenario.
2. Submit the Producer API and require HTTP 202.
3. Extract the intake ID and lifecycle ID from the Producer response.
4. Wait for the configurable processing delay (12 seconds by default).
5. Submit RxCore with the Producer intake ID. Lifecycle mapping is disabled by default, matching the confirmed flow.
6. Extract the order number and any Rx numbers from the RxCore response.
7. Open QA1, QA2 or QA3 ePost in Edge IE mode.
8. Log in, search by order number, retry until the order appears, and validate patient/client/Rx details.
9. Create a compact HTML execution report and linked screenshots.

Supported clients are CPD, AssistRx, Andel and Apaly. AssistRx intentionally expects `Coassist` in ePost. CPD expects `ESCRIPT`; the other clients expect `TRANSFERRED`.

## Project layout

```text
src/EpostRxCore.Tests/
  Api/             token, headers, Producer and RxCore calls
  Base/            NUnit setup and report lifecycle
  Configuration/   environment switching and protected-variable names
  Data/            clients, patient generation and payload templates
  Drivers/         Edge and Edge IE-mode driver creation
  Models/          shared response and UI models
  Pages/           ePost page objects
  Reporting/       HTML report and screenshot support
  Tests/           self, functional, negative and connectivity tests
  Utilities/       JSON and retry helpers
  Workflow/        end-to-end orchestration
```

## First setup on the work laptop

Open the `EpostRxCoreAutomation` folder in VS Code. Use the existing .NET 8 SDK; the project targets `net8.0` even if .NET 9 is also installed.

Set the protected values in the same PowerShell window used to run tests. Never save real values in JSON or Git.

```powershell
$env:EPOST_API_BEARER_TOKEN = "current Apigee bearer token"
$env:EPOST_PIS_API_KEY = "PIS API key"
$env:EPOST_USERNAME = "ePost username"
$env:EPOST_PASSWORD = "ePost password"
$env:EPOST_SITE_PIN = "site PIN"
$env:EPOST_IE_DRIVER_DIRECTORY = "C:\ApprovedTools\IEDriver"
```

`EPOST_IE_DRIVER_DIRECTORY` must contain `IEDriverServer.exe`. Edge IE mode must remain managed by the enterprise site list. If an Apigee client-credential token is later available, set `EPOST_API_CLIENT_ID`, `EPOST_API_CLIENT_SECRET`, and `EPOST_API_SCOPE`, and update the token URL in `TestData/appsettings.json`.

## Run commands

Safe offline check (no QA or browser call):

```powershell
.\scripts\Run-SelfTests.ps1
```

Open ePost only:

```powershell
.\scripts\Run-EpostConnectivity.ps1
```

Run one complete example:

```powershell
.\scripts\Run-Functional.ps1 -Client CPD -Scenario OneRx -EpostEnvironment QA3
```

Other scenarios are `MultipleRx` and `ExistingPatient`. Reports are written under `TestResults`, with screenshots under each report's `Screenshots` folder.

## Configuration

- Switch ePost using `EPOST_ENVIRONMENT=QA1`, `QA2`, or `QA3`.
- Change the Producer/RxCore delay in `TestData/appsettings.json`.
- Change ePost polling interval/timeout in the same file.
- Client rules are isolated in `TestData/clients.json`.
- Full API bodies are isolated in `TestData/Templates`; test code does not contain large JSON strings.
- Real functional and negative tests are marked `Explicit`, preventing accidental QA calls from a plain `dotnet test`.

## Important boundary

The success/failure event payload visible only in developer logs must still be validated manually in qTest. This framework does not report that step as automated.
