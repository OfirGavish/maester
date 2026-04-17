---
title: MT.1125 - Ensure ASR Rules are configured correctly
description: Checks if Attack Surface Reduction (ASR) rules are configured with at least one rule enabled in Intune.
slug: /tests/MT.1125
sidebar_class_name: hidden
---

# Ensure ASR Rules are configured correctly

## Description

Attack Surface Reduction (ASR) rules help prevent actions and apps that are typically used by exploit-seeking malware to infect machines. This check verifies that at least one Intune Endpoint Security Attack Surface Reduction policy exists with at least one ASR rule set to Block, Audit, or Warn mode (not Off). It reports the number of active vs. total rules configured per policy.

## How to fix

1. Navigate to [Microsoft Intune admin center](https://intune.microsoft.com).
2. Click **Endpoint security** > **Attack surface reduction**.
3. Click **Create policy**.
4. Select **Windows** as the platform.
5. Select **Attack Surface Reduction Rules** as the profile type.
6. Enable the desired ASR rules in **Block** or **Audit** mode. It is recommended to start with Audit mode to assess impact before switching to Block.
7. Assign the policy to the appropriate device groups.
8. Click **Create**.

## Learn more

* [Attack surface reduction rules overview](https://learn.microsoft.com/en-us/defender-endpoint/attack-surface-reduction)
* [Enable attack surface reduction rules](https://learn.microsoft.com/en-us/defender-endpoint/enable-attack-surface-reduction)
* [ASR rules deployment guide](https://learn.microsoft.com/en-us/defender-endpoint/attack-surface-reduction-rules-deployment)
