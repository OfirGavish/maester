function Test-MtIntuneLAPSConfiguration {
    <#
    .SYNOPSIS
    Checks if a Windows LAPS Configuration policy is set in Intune.

    .DESCRIPTION
    This function verifies that at least one Intune Endpoint Security Account
    Protection policy exists for Windows LAPS (Local Administrator Password
    Solution) with password backup enabled. LAPS ensures that local
    administrator passwords are unique, randomly generated, and regularly
    rotated on managed devices.

    The check queries configuration policies filtered by the
    endpointSecurityAccountProtection template family and looks for policies
    using the "Local admin password solution (Windows LAPS)" template
    (templateId: adc46e5a-f4aa-4ff6-aeff-4f27bc525796). It then verifies
    that the BackupDirectory setting is configured to back up to either
    Microsoft Entra ID or Active Directory (not disabled).

    .EXAMPLE
    Test-MtIntuneLAPSConfiguration

    Returns true if a LAPS configuration policy with backup enabled is found.

    .LINK
    https://maester.dev/docs/commands/Test-MtIntuneLAPSConfiguration
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if (-not (Get-MtLicenseInformation -Product Intune)) {
        Add-MtTestResultDetail -SkippedBecause NotLicensedIntune
        return $null
    }

    try {
        Write-Verbose 'Retrieving Intune LAPS configuration policies...'
        $lapsTemplateId = 'adc46e5a-f4aa-4ff6-aeff-4f27bc525796'
        $filter = "templateReference/TemplateFamily eq 'endpointSecurityAccountProtection'"
        $select = 'id,name,description,platforms,lastModifiedDateTime,technologies,settingCount,roleScopeTagIds,isAssigned,templateReference'
        $policies = Invoke-MtGraphRequest -RelativeUri "deviceManagement/configurationPolicies?`$select=$select&`$filter=$filter" -ApiVersion beta

        # Filter to only LAPS template policies
        $lapsPolicies = @($policies | Where-Object {
            $_.templateReference.templateId -like "$lapsTemplateId*"
        })

        $backupEnabledPolicies = @()
        foreach ($policy in $lapsPolicies) {
            $settings = Invoke-MtGraphRequest -RelativeUri "deviceManagement/configurationPolicies('$($policy.id)')/settings" -ApiVersion beta
            $backupSetting = $settings | Where-Object {
                $_.settingInstance.settingDefinitionId -eq 'device_vendor_msft_laps_policies_backupdirectory'
            }
            if ($backupSetting) {
                $backupValue = $backupSetting.settingInstance.choiceSettingValue.value
                # _0 = disabled, _1 = Entra ID, _2 = Active Directory
                if ($backupValue -ne 'device_vendor_msft_laps_policies_backupdirectory_0') {
                    $backupTarget = switch ($backupValue) {
                        'device_vendor_msft_laps_policies_backupdirectory_1' { 'Microsoft Entra ID' }
                        'device_vendor_msft_laps_policies_backupdirectory_2' { 'Active Directory' }
                        default { 'Unknown' }
                    }
                    $backupEnabledPolicies += [PSCustomObject]@{
                        Name           = $policy.name
                        BackupTarget   = $backupTarget
                        IsAssigned     = $policy.isAssigned
                        LastModified   = $policy.lastModifiedDateTime
                    }
                }
            }
        }

        $testResultMarkdown = ''
        if ($backupEnabledPolicies.Count -gt 0) {
            $testResultMarkdown += "LAPS Configuration Policies with backup enabled:`n"
            $testResultMarkdown += "| Name | Backup Target | Assigned | Last Modified |`n"
            $testResultMarkdown += "| --- | --- | --- | --- |`n"
            foreach ($policy in $backupEnabledPolicies) {
                $testResultMarkdown += "| $($policy.Name) | $($policy.BackupTarget) | $($policy.IsAssigned) | $($policy.LastModified) |`n"
            }
        } else {
            $testResultMarkdown += 'No LAPS Configuration policy with password backup enabled found in Intune.'
        }

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $backupEnabledPolicies.Count -gt 0
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}
