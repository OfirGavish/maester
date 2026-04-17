Describe "Maester/Intune" -Tag "Maester", "Intune", "Security" {
    It "MT.1200: Ensure LAPS Configuration Policy is properly set. See https://maester.dev/docs/tests/MT.1200" -Tag "MT.1200" {
        $result = Test-MtIntuneLAPSConfiguration
        if ($null -ne $result) {
            $result | Should -Be $true -Because "a LAPS Configuration policy with password backup enabled should exist in Intune."
        }
    }

    It "MT.1201: Ensure ASR Rules are configured correctly. See https://maester.dev/docs/tests/MT.1201" -Tag "MT.1201" {
        $result = Test-MtIntuneASRRules
        if ($null -ne $result) {
            $result | Should -Be $true -Because "at least one ASR policy with active rules (Block, Audit, or Warn) should be configured in Intune."
        }
    }

    It "MT.1202: Ensure App Control for Business is enabled. See https://maester.dev/docs/tests/MT.1202" -Tag "MT.1202" {
        $result = Test-MtIntuneAppControl
        if ($null -ne $result) {
            $result | Should -Be $true -Because "at least one App Control for Business policy should be configured in Intune."
        }
    }

    It "MT.1203: Ensure Managed Installer is enabled. See https://maester.dev/docs/tests/MT.1203" -Tag "MT.1203" {
        $result = Test-MtIntuneManagedInstallerRules
        if ($null -ne $result) {
            $result | Should -Be $true -Because "at least one Managed Installer script should be enabled in Intune."
        }
    }
}
