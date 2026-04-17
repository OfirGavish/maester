function Test-MtIntuneLAPSConfiguration {
    <#
    .SYNOPSIS
    Checks if a LAPS Configuration policy is set in Intune.

    .DESCRIPTION
    This function verifies that at least one Intune configuration policy exists
    for Windows LAPS (Local Administrator Password Solution). LAPS ensures that
    local administrator passwords are unique, randomly generated, and regularly
    rotated on managed devices.

    .EXAMPLE
    Test-MtIntuneLAPSConfiguration

    Returns true if a LAPS configuration policy is found in Intune.

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
        Write-Verbose 'Retrieving Intune configuration policies for LAPS...'
        $policies = Invoke-MtGraphRequest -RelativeUri 'deviceManagement/configurationPolicies' -ApiVersion beta

        $lapsPolicies = @($policies | Where-Object {
            $_.templateReference.templateFamily -eq 'endpointSecurityAccountProtection' -or
            $_.name -like '*LAPS*'
        })

        $testResultMarkdown = ''
        if ($lapsPolicies.Count -gt 0) {
            $testResultMarkdown += "LAPS Configuration Policies found:`n"
            $testResultMarkdown += "| Name | Created | Last Modified |`n"
            $testResultMarkdown += "| --- | --- | --- |`n"
            foreach ($policy in $lapsPolicies) {
                $testResultMarkdown += "| $($policy.name) | $($policy.createdDateTime) | $($policy.lastModifiedDateTime) |`n"
            }
        } else {
            $testResultMarkdown += 'No LAPS Configuration policy found in Intune.'
        }

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $lapsPolicies.Count -gt 0
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}
