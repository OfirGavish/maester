---
title: "MT.1202 - Ensure App Control for Business is enabled"
description: Checks if an App Control for Business (WDAC) policy is configured in Intune.
slug: /tests/MT.1202
sidebar_class_name: hidden
---

# Ensure App Control for Business is enabled

## Description

App Control for Business (formerly Windows Defender Application Control / WDAC) restricts which applications are allowed to run on managed devices, reducing the attack surface. This check verifies that at least one Intune configuration policy exists for App Control.

## How to fix

1. Navigate to [Microsoft Intune admin center](https://intune.microsoft.com).
2. Click **Endpoint security** > **Application control**.
3. Click **Create policy**.
4. Select **Windows 10, Windows 11, and Windows Server** as the platform.
5. Select **App Control for Business** as the profile type.
6. Configure the policy according to your organizational needs.
7. Assign the policy to the appropriate device groups.
8. Click **Create**.

## Learn more

* [App Control for Business with Intune](https://learn.microsoft.com/en-us/intune/intune-service/protect/endpoint-security-app-control-policy)
* [Application control for Windows](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/app-control-for-business/appcontrol)
