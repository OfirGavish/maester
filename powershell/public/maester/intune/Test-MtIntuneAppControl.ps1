function Test-MtIntuneAppControl {
    <#
    .SYNOPSIS
    Checks if an App Control for Business policy is configured in Intune.

    .DESCRIPTION
    This function verifies that at least one Intune Endpoint Security policy
    configures Windows Defender Application Control (WDAC) / App Control for
    Business. App Control policies restrict which applications are allowed to
    run on managed devices, reducing the attack surface.

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
        $policies = Invoke-MtGraphRequest -RelativeUri 'deviceManagement/configurationPolicies' -ApiVersion beta

        $appControlPolicies = @($policies | Where-Object {
            $_.templateReference.templateFamily -eq 'endpointSecurityApplicationControl' -or
            $_.name -like '*App Control*' -or
            $_.name -like '*Application Control*' -or
            $_.name -like '*WDAC*'
        })

        $testResultMarkdown = ''
        if ($appControlPolicies.Count -gt 0) {
            $testResultMarkdown += "App Control Policies found:`n"
            $testResultMarkdown += "| Name | Created | Last Modified |`n"
            $testResultMarkdown += "| --- | --- | --- |`n"
            foreach ($policy in $appControlPolicies) {
                $testResultMarkdown += "| $($policy.name) | $($policy.createdDateTime) | $($policy.lastModifiedDateTime) |`n"
            }
        } else {
            $testResultMarkdown += 'No App Control for Business policy found in Intune.'
        }

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $appControlPolicies.Count -gt 0
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}
