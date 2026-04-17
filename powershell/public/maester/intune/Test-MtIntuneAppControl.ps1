function Test-MtIntuneAppControl {
    <#
    .SYNOPSIS
    Checks if an App Control for Business policy is configured in Intune.

    .DESCRIPTION
    This function verifies that at least one Intune Endpoint Security policy
    configures App Control for Business (formerly Windows Defender Application
    Control / WDAC). App Control policies restrict which applications are
    allowed to run on managed devices, reducing the attack surface.

    The check queries configuration policies filtered by the
    endpointSecurityApplicationControl template family and inspects each
    policy's settings to report:
    - Policy creation type (built-in controls or XML upload)
    - Audit mode (enabled/disabled)
    - Trust apps from managed installer (enabled/disabled)
    - Trust apps with good reputation / ISG (enabled/disabled)

    .EXAMPLE
    Test-MtIntuneAppControl

    Returns true if an App Control for Business policy is found in Intune.

    .LINK
    https://maester.dev/docs/commands/Test-MtIntuneAppControl
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if (-not (Get-MtLicenseInformation -Product Intune)) {
        Add-MtTestResultDetail -SkippedBecause NotLicensedIntune
        return $null
    }

    try {
        Write-Verbose 'Retrieving Intune App Control policies...'
        $appControlTemplateId = 'd3849ba8-bf95-467c-9640-aa2334eae9e3'
        $filter = "templateReference/TemplateFamily eq 'endpointSecurityApplicationControl'"
        $select = 'id,name,description,platforms,lastModifiedDateTime,technologies,settingCount,roleScopeTagIds,isAssigned,templateReference'
        $policies = Invoke-MtGraphRequest -RelativeUri "deviceManagement/configurationPolicies?`$select=$select&`$filter=$filter" -ApiVersion beta

        $appControlPolicies = @($policies | Where-Object {
            $_.templateReference.templateId -like "$appControlTemplateId*"
        })

        $policyDetails = @()
        foreach ($policy in $appControlPolicies) {
            $settings = Invoke-MtGraphRequest -RelativeUri "deviceManagement/configurationPolicies('$($policy.id)')/settings" -ApiVersion beta

            $buildOptionsSetting = $settings | Where-Object {
                $_.settingInstance.settingDefinitionId -eq 'device_vendor_msft_policy_config_applicationcontrolv2_buildoptions'
            }

            $policyType = 'Unknown'
            $auditMode = 'N/A'
            $trustManagedInstaller = 'N/A'
            $trustGoodReputation = 'N/A'

            if ($buildOptionsSetting) {
                $buildValue = $buildOptionsSetting.settingInstance.choiceSettingValue.value
                if ($buildValue -like '*built_in_controls_selected') {
                    $policyType = 'Built-in controls'
                    foreach ($child in $buildOptionsSetting.settingInstance.choiceSettingValue.children) {
                        switch ($child.settingDefinitionId) {
                            'device_vendor_msft_policy_config_applicationcontrolv2_auditmode' {
                                $auditMode = if ($child.choiceSettingValue.value -like '*_enabled') { 'Enabled' } else { 'Disabled' }
                            }
                            'device_vendor_msft_policy_config_applicationcontrolv2_trustappsfrommanagedinstaller' {
                                $trustManagedInstaller = if ($child.choiceSettingValue.value -like '*_enabled') { 'Enabled' } else { 'Disabled' }
                            }
                            'device_vendor_msft_policy_config_applicationcontrolv2_trustappswithgoodreputation' {
                                $trustGoodReputation = if ($child.choiceSettingValue.value -like '*_enabled') { 'Enabled' } else { 'Disabled' }
                            }
                        }
                    }
                } elseif ($buildValue -like '*upload_xml_selected') {
                    $policyType = 'XML upload'
                }
            }

            $policyDetails += [PSCustomObject]@{
                Name                  = $policy.name
                PolicyType            = $policyType
                AuditMode             = $auditMode
                TrustManagedInstaller = $trustManagedInstaller
                TrustGoodReputation   = $trustGoodReputation
                IsAssigned            = $policy.isAssigned
                LastModified          = $policy.lastModifiedDateTime
            }
        }

        $testResultMarkdown = ''
        if ($policyDetails.Count -gt 0) {
            $testResultMarkdown += "App Control for Business policies found:`n"
            $testResultMarkdown += "| Name | Type | Audit Mode | Trust Managed Installer | Trust Good Reputation | Assigned | Last Modified |`n"
            $testResultMarkdown += "| --- | --- | --- | --- | --- | --- | --- |`n"
            foreach ($detail in $policyDetails) {
                $testResultMarkdown += "| $($detail.Name) | $($detail.PolicyType) | $($detail.AuditMode) | $($detail.TrustManagedInstaller) | $($detail.TrustGoodReputation) | $($detail.IsAssigned) | $($detail.LastModified) |`n"
            }
        } else {
            $testResultMarkdown += 'No App Control for Business policy found in Intune.'
        }

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $policyDetails.Count -gt 0
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}
