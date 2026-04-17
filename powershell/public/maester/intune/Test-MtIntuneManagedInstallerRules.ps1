function Test-MtIntuneManagedInstallerRules {
    <#
    .SYNOPSIS
    Checks if Managed Installer is configured in Intune.

    .DESCRIPTION
    This function verifies that at least one Intune device health script
    configures the Managed Installer (deviceHealthScriptType =
    managedInstallerScript). Managed Installer works with App Control for
    Business to automatically allow applications deployed through authorized
    management solutions (such as Intune) to run on managed devices.

    The check queries deviceManagement/deviceHealthScripts filtered by
    managedInstallerScript type and verifies that the "Enabled" parameter
    is set to "True". It also reports assignment and run summary status.

    .EXAMPLE
    Test-MtIntuneManagedInstallerRules

    Returns true if Managed Installer is enabled in Intune.

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
        Write-Verbose 'Retrieving Intune Managed Installer scripts...'
        $filter = "deviceHealthScriptType eq 'managedInstallerScript'"
        $scripts = Invoke-MtGraphRequest -RelativeUri "deviceManagement/deviceHealthScripts?`$expand=assignments,runSummary&`$filter=$filter" -ApiVersion beta

        $enabledScripts = @($scripts | Where-Object {
            $enabledParam = $_.detectionScriptParameters | Where-Object { $_.name -eq 'Enabled' }
            $enabledParam -and $enabledParam.defaultValue -eq 'True'
        })

        $testResultMarkdown = ''
        if ($enabledScripts.Count -gt 0) {
            $testResultMarkdown += "Managed Installer scripts found:`n"
            $testResultMarkdown += "| Name | Assignments | Created | Last Modified |`n"
            $testResultMarkdown += "| --- | --- | --- | --- |`n"
            foreach ($script in $enabledScripts) {
                $assignmentCount = @($script.assignments).Count
                $testResultMarkdown += "| $($script.displayName) | $assignmentCount | $($script.createdDateTime) | $($script.lastModifiedDateTime) |`n"
            }
        } else {
            $testResultMarkdown += 'No Managed Installer scripts enabled in Intune.'
        }

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $enabledScripts.Count -gt 0
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}
