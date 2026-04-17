---
title: MT.1127 - Ensure Managed Installer is enabled
description: Checks if a Managed Installer script is enabled in Intune for App Control.
slug: /tests/MT.1127
sidebar_class_name: hidden
---

# Ensure Managed Installer is enabled

## Description

Managed Installer works with App Control for Business to automatically allow applications deployed through authorized management solutions (such as Intune) to run on managed devices. This check verifies that at least one Intune device health script of type `managedInstallerScript` exists with the Enabled parameter set to True. It also reports assignment status.

## How to fix

1. Navigate to [Microsoft Intune admin center](https://intune.microsoft.com).
2. Click **Endpoint security** > **App Control for Business**.
3. Select the **Managed Installer** tab.
4. Click **Add** to create a new Managed Installer policy.
5. Configure the policy name and settings.
6. Assign the policy to the appropriate device groups.
7. Click **Create**.

## Learn more

* [Allow apps installed by a managed installer with App Control for Business](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/app-control-for-business/design/configure-appcontrol-managed-installer)
* [Managed Installer with Microsoft Intune](https://learn.microsoft.com/en-us/intune/intune-service/protect/endpoint-security-app-control-policy)
