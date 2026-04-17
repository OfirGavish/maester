---
title: MT.1200 - Ensure LAPS Configuration Policy is properly set
description: Checks if a Windows LAPS policy is configured in Intune with password backup enabled to Entra ID or Active Directory.
slug: /tests/MT.1200
sidebar_class_name: hidden
---

# Ensure LAPS Configuration Policy is properly set

## Description

Windows LAPS (Local Administrator Password Solution) ensures that local administrator passwords are unique, randomly generated, and regularly rotated on managed devices. This check verifies that at least one Intune Endpoint Security Account Protection policy exists for Windows LAPS with the Backup Directory setting configured to back up passwords to either Microsoft Entra ID or Active Directory (not disabled).

## How to fix

1. Navigate to [Microsoft Intune admin center](https://intune.microsoft.com).
2. Click **Endpoint security** > **Account protection**.
3. Click **Create policy**.
4. Select **Windows** as the platform.
5. Select **Local admin password solution (Windows LAPS)** as the profile type.
6. Set **Backup Directory** to **Back up the password to Microsoft Entra ID** or **Back up the password to Active Directory**.
7. Configure additional settings (password complexity, rotation, etc.) according to your organizational needs.
8. Assign the policy to the appropriate device groups.
9. Click **Create**.

## Learn more

* [Windows LAPS with Microsoft Intune](https://learn.microsoft.com/en-us/intune/intune-service/protect/windows-laps-overview)
* [Configure Windows LAPS policy settings](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-scenarios-azure-active-directory)
