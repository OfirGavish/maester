---
title: "MT.1203 - Ensure Managed Installer Rules are configured correctly"
description: Checks if Managed Installer rules are configured in Intune for App Control.
slug: /tests/MT.1203
sidebar_class_name: hidden
---

# Ensure Managed Installer Rules are configured correctly

## Description

Managed Installer works with App Control for Business to automatically allow applications deployed through authorized management solutions (such as Intune) to run on managed devices. This check verifies that at least one Intune configuration policy enables Managed Installer.

## How to fix

1. Navigate to [Microsoft Intune admin center](https://intune.microsoft.com).
2. Click **Endpoint security** > **Application control**.
3. Click **Create policy**.
4. Select **Windows 10, Windows 11, and Windows Server** as the platform.
5. Select **Managed Installer** as the profile type.
6. Set **Set managed installer** to **On**.
7. Assign the policy to the appropriate device groups.
8. Click **Create**.

## Learn more

* [Allow apps installed by a managed installer with App Control for Business](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/app-control-for-business/design/configure-appcontrol-managed-installer)
* [Managed Installer and ISG technical reference](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/app-control-for-business/design/configure-appcontrol-managed-installer)
