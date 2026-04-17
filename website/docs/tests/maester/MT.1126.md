---
title: MT.1126 - Ensure App Control for Business is enabled
description: Checks if an App Control for Business policy is configured in Intune.
slug: /tests/MT.1126
sidebar_class_name: hidden
---

# Ensure App Control for Business is enabled

## Description

App Control for Business restricts which applications are allowed to run on managed devices, reducing the attack surface. This check verifies that at least one Intune Endpoint Security Application Control policy exists. It reports the policy type (built-in controls or XML upload) and, for built-in control policies, the status of audit mode, trust apps from managed installer, and trust apps with good reputation (ISG).

## How to fix

1. Navigate to [Microsoft Intune admin center](https://intune.microsoft.com).
2. Click **Endpoint security** > **App Control for Business**.
3. Click **Create policy**.
4. Select **Windows** as the platform.
5. Select **App Control for Business** as the profile type.
6. Choose **Use built-in controls** or **Upload an XML policy file**.
7. For built-in controls, configure audit mode, trust apps from managed installer, and trust apps with good reputation as needed.
8. Assign the policy to the appropriate device groups.
9. Click **Create**.

## Learn more

* [App Control for Business with Intune](https://learn.microsoft.com/en-us/intune/intune-service/protect/endpoint-security-app-control-policy)
* [Application control for Windows](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/app-control-for-business/appcontrol)
