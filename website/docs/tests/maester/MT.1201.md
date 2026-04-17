---
title: "MT.1201 - Ensure ASR Rules are configured correctly"
description: Checks if Attack Surface Reduction (ASR) rules are configured in Intune.
slug: /tests/MT.1201
sidebar_class_name: hidden
---

# Ensure ASR Rules are configured correctly

## Description

Attack Surface Reduction (ASR) rules help prevent actions and apps that are typically used by exploit-seeking malware to infect machines. This check verifies that at least one Intune Endpoint Security policy configures ASR rules.

## How to fix

1. Navigate to [Microsoft Intune admin center](https://intune.microsoft.com).
2. Click **Endpoint security** > **Attack surface reduction**.
3. Click **Create policy**.
4. Select **Windows 10, Windows 11, and Windows Server** as the platform.
5. Select **Attack Surface Reduction Rules** as the profile type.
6. Configure the ASR rules according to your organizational needs.
7. Assign the policy to the appropriate device groups.
8. Click **Create**.

## Learn more

* [Attack surface reduction rules overview](https://learn.microsoft.com/en-us/defender-endpoint/attack-surface-reduction)
* [Enable attack surface reduction rules](https://learn.microsoft.com/en-us/defender-endpoint/enable-attack-surface-reduction)
