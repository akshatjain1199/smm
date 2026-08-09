# qTest and Azure pipeline setup

## qTest

The confirmed qTest project is **SAFe-Pharmacy and PBM**, project ID **135338**. The previously shown test run is **TR-158303**. That run covers a developer-log event validation and should remain manual because automation cannot access those logs.

For an automatable RxCore scenario:

1. Reuse or create the matching functional test case in Test Design.
2. Add it to the correct 26.08 Test Cycle/Test Suite in Test Execution.
3. Open the Test Run and set **Automation Content** to the exact NUnit test name, for example `TC_RXCORE_001_NewPatient_OneRx_CPD`.
4. In the Selenium Test Runner and qTest Integrator, select the Test Run and verify the Automation Content column is populated.
5. Run the selected test. Upload the generated HTML report and screenshots if the local qTest runner does not attach them automatically.

Do not paste an Azure PAT, qTest token, bearer token, PIS key, password, or PIN into source files or screenshots. A PAT is not required for a normal Azure pipeline checkout; use the pipeline service identity.

## Azure DevOps

The supplied `azure-pipelines.yml` follows the existing repository conventions:

- self-hosted pool `QualityEnablement`
- variable group `BATS_Testing`
- .NET 8 SDK
- restore, build, safe self-tests, optional selected functional test
- TRX publishing and a report/screenshot artifact

Create secret variables in the `BATS_Testing` variable group using the names shown in the YAML. Mark every credential/token/key as secret. `EPOST_IE_DRIVER_DIRECTORY` is a normal path variable.

The functional browser job requires a Windows agent that has:

- network access to QA APIs and ePost
- Edge with the enterprise IE-mode site list
- an approved `IEDriverServer.exe`
- an interactive desktop session; a locked/non-interactive service agent may run API tests but cannot reliably drive this legacy UI

Keep `runFunctional=false` for ordinary builds. Set it to `true` only for an approved QA run and enter the exact NUnit test name from the test matrix.
