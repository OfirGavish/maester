function Test-MtIntuneASRRules {
    <#
    .SYNOPSIS
    Checks if Attack Surface Reduction (ASR) rules are configured in Intune.

    .DESCRIPTION
    This function verifies that at least one Intune Endpoint Security policy
    configures Attack Surface Reduction (ASR) rules. ASR rules help prevent
    actions and apps that are typically used by exploit-seeking malware to
    infect machines.

    .EXAMPLE
    Test-MtIntuneASRRules

    Returns true if ASR rules are configured in Intune.

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
        $policies = Invoke-MtGraphRequest -RelativeUri 'deviceManagement/configurationPolicies' -ApiVersion beta

        $asrPolicies = @($policies | Where-Object {
            $_.templateReference.templateFamily -eq 'endpointSecurityAttackSurfaceReduction' -or
            $_.name -like '*ASR*' -or
            $_.name -like '*Attack Surface Reduction*'
        })

        $testResultMarkdown = ''
        if ($asrPolicies.Count -gt 0) {
            $testResultMarkdown += "ASR Policies found:`n"
            $testResultMarkdown += "| Name | Created | Last Modified |`n"
            $testResultMarkdown += "| --- | --- | --- |`n"
            foreach ($policy in $asrPolicies) {
                $testResultMarkdown += "| $($policy.name) | $($policy.createdDateTime) | $($policy.lastModifiedDateTime) |`n"
            }
        } else {
            $testResultMarkdown += 'No Attack Surface Reduction (ASR) rules found in Intune.'
        }

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $asrPolicies.Count -gt 0
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}
