Describe "Maester/Intune" -Tag "Maester", "Intune", "Security" {
    It "MT.1124: Ensure LAPS Configuration Policy is properly set. See https://maester.dev/docs/tests/MT.1124" -Tag "MT.1124" {
        $result = Test-MtIntuneLAPSConfiguration
        if ($null -ne $result) {
            $result | Should -Be $true -Because "a LAPS Configuration policy with password backup enabled should exist in Intune."
        }
    }

    It "MT.1125: Ensure ASR Rules are configured correctly. See https://maester.dev/docs/tests/MT.1125" -Tag "MT.1125" {
        $result = Test-MtIntuneASRRules
        if ($null -ne $result) {
            $result | Should -Be $true -Because "at least one ASR policy with active rules (Block, Audit, or Warn) should be configured in Intune."
        }
    }

    It "MT.1126: Ensure App Control for Business is enabled. See https://maester.dev/docs/tests/MT.1126" -Tag "MT.1126" {
        $result = Test-MtIntuneAppControl
        if ($null -ne $result) {
            $result | Should -Be $true -Because "at least one App Control for Business policy should be configured in Intune."
        }
    }

    It "MT.1127: Ensure Managed Installer is enabled. See https://maester.dev/docs/tests/MT.1127" -Tag "MT.1127" {
        $result = Test-MtIntuneManagedInstallerRules
        if ($null -ne $result) {
            $result | Should -Be $true -Because "at least one Managed Installer script should be enabled in Intune."
        }
    }
}
