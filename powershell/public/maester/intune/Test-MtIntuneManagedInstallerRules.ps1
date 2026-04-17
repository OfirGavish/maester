function Test-MtIntuneManagedInstallerRules {
    <#
    .SYNOPSIS
    Checks if Managed Installer rules are configured in Intune.

    .DESCRIPTION
    This function verifies that at least one Intune configuration policy
    enables Managed Installer. Managed Installer works with App Control for
    Business to automatically allow applications deployed through authorized
    management solutions (such as Intune) to run on managed devices.

    .EXAMPLE
    Test-MtIntuneManagedInstallerRules

    Returns true if Managed Installer rules are configured in Intune.

    .LINK
    https://maester.dev/docs/commands/Test-MtIntuneManagedInstallerRules
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Managed Installer Rules is a product concept.')]
    param()

    if (-not (Get-MtLicenseInformation -Product Intune)) {
        Add-MtTestResultDetail -SkippedBecause NotLicensedIntune
        return $null
    }

    try {
        Write-Verbose 'Retrieving Intune Managed Installer policies...'
        $policies = Invoke-MtGraphRequest -RelativeUri 'deviceManagement/configurationPolicies' -ApiVersion beta

        $managedInstallerPolicies = @($policies | Where-Object {
            $_.templateReference.templateFamily -eq 'endpointSecurityApplicationControl' -or
            $_.name -like '*Managed Installer*'
        })

        $testResultMarkdown = ''
        if ($managedInstallerPolicies.Count -gt 0) {
            $testResultMarkdown += "Managed Installer Policies found:`n"
            $testResultMarkdown += "| Name | Created | Last Modified |`n"
            $testResultMarkdown += "| --- | --- | --- |`n"
            foreach ($policy in $managedInstallerPolicies) {
                $testResultMarkdown += "| $($policy.name) | $($policy.createdDateTime) | $($policy.lastModifiedDateTime) |`n"
            }
        } else {
            $testResultMarkdown += 'No Managed Installer rules found in Intune.'
        }

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $managedInstallerPolicies.Count -gt 0
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}
