function Test-MtIntuneASRRules {
    <#
    .SYNOPSIS
    Checks if Attack Surface Reduction (ASR) rules are configured in Intune.

    .DESCRIPTION
    This function verifies that at least one Intune Endpoint Security policy
    configures Attack Surface Reduction (ASR) rules with at least one rule
    set to Block, Audit, or Warn mode. ASR rules help prevent actions and
    apps that are typically used by exploit-seeking malware to infect machines.

    The check queries configuration policies filtered by the
    endpointSecurityAttackSurfaceReduction template family and looks for
    policies using the "Attack Surface Reduction Rules" template
    (templateId: e8c053d6-9f95-42b1-a7f1-ebfd71c67a4b). It then inspects
    each policy's settings to verify that at least one ASR rule is not
    set to Off.

    .EXAMPLE
    Test-MtIntuneASRRules

    Returns true if ASR rules are configured (not all Off) in Intune.

    .LINK
    https://maester.dev/docs/commands/Test-MtIntuneASRRules
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'ASR Rules is a product name.')]
    param()

    if (-not (Get-MtLicenseInformation -Product Intune)) {
        Add-MtTestResultDetail -SkippedBecause NotLicensedIntune
        return $null
    }

    try {
        Write-Verbose 'Retrieving Intune Endpoint Security ASR policies...'
        $asrTemplateId = 'e8c053d6-9f95-42b1-a7f1-ebfd71c67a4b'
        $filter = "templateReference/TemplateFamily eq 'endpointSecurityAttackSurfaceReduction'"
        $select = 'id,name,description,platforms,lastModifiedDateTime,technologies,settingCount,roleScopeTagIds,isAssigned,templateReference'
        $policies = Invoke-MtGraphRequest -RelativeUri "deviceManagement/configurationPolicies?`$select=$select&`$filter=$filter" -ApiVersion beta

        # Filter to ASR Rules template policies
        $asrPolicies = @($policies | Where-Object {
            $_.templateReference.templateId -like "$asrTemplateId*"
        })

        $activePolicies = @()
        foreach ($policy in $asrPolicies) {
            $settings = Invoke-MtGraphRequest -RelativeUri "deviceManagement/configurationPolicies('$($policy.id)')/settings" -ApiVersion beta
            # Count ASR rules that are not set to Off (suffix _off)
            $asrRuleSetting = $settings | Where-Object {
                $_.settingInstance.settingDefinitionId -eq 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
            }
            $activeRuleCount = 0
            $totalRuleCount = 0
            if ($asrRuleSetting -and $asrRuleSetting.settingInstance.groupSettingCollectionValue) {
                foreach ($group in $asrRuleSetting.settingInstance.groupSettingCollectionValue) {
                    foreach ($child in $group.children) {
                        if ($child.settingDefinitionId -like 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_*' -and
                            $child.settingDefinitionId -notlike '*_perruleexclusions') {
                            $totalRuleCount++
                            if ($child.choiceSettingValue.value -notlike '*_off') {
                                $activeRuleCount++
                            }
                        }
                    }
                }
            }

            if ($activeRuleCount -gt 0) {
                $activePolicies += [PSCustomObject]@{
                    Name             = $policy.name
                    ActiveRules      = $activeRuleCount
                    TotalRules       = $totalRuleCount
                    IsAssigned       = $policy.isAssigned
                    LastModified     = $policy.lastModifiedDateTime
                }
            }
        }

        $testResultMarkdown = ''
        if ($activePolicies.Count -gt 0) {
            $testResultMarkdown += "ASR Policies with active rules:`n"
            $testResultMarkdown += "| Name | Active Rules | Total Rules | Assigned | Last Modified |`n"
            $testResultMarkdown += "| --- | --- | --- | --- | --- |`n"
            foreach ($policy in $activePolicies) {
                $testResultMarkdown += "| $($policy.Name) | $($policy.ActiveRules) | $($policy.TotalRules) | $($policy.IsAssigned) | $($policy.LastModified) |`n"
            }
        } else {
            $testResultMarkdown += 'No Attack Surface Reduction (ASR) rules configured (or all rules set to Off) in Intune.'
        }

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $activePolicies.Count -gt 0
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}
