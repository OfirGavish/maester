Describe "Maester/Intune" -Tag "Maester", "Intune", "Security" {
    It "MT.1200: Ensure LAPS Configuration Policy is properly set" -Tag "MT.1200" {
        $result = Test-MtIntuneLAPSConfiguration
        if ($null -ne $result) {
            $result | Should -Be $true -Because "a LAPS Configuration policy is properly set in Intune."
        }
    }

    It "MT.1201: Ensure ASR Rules are configured correctly" -Tag "MT.1201" {
        $result = Test-MtIntuneASRRules
        if ($null -ne $result) {
            $result | Should -Be $true -Because "Attack Surface Reduction (ASR) rules are configured in Intune."
        }
    }

    It "MT.1202: Ensure App Control for Business is enabled" -Tag "MT.1202" {
        $result = Test-MtIntuneAppControl
        if ($null -ne $result) {
            $result | Should -Be $true -Because "App Control for Business is enabled in Intune."
        }
    }

    It "MT.1203: Ensure Managed Installer Rules are configured correctly" -Tag "MT.1203" {
        $result = Test-MtIntuneManagedInstallerRules
        if ($null -ne $result) {
            $result | Should -Be $true -Because "Managed Installer rules are configured in Intune."
        }
    }
}
