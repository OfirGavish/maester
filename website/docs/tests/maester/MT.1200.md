---
title: "MT.1200 - Ensure LAPS Configuration Policy is properly set"
description: Checks if a LAPS (Local Administrator Password Solution) Configuration policy is set in Intune.
slug: /tests/MT.1200
sidebar_class_name: hidden
---

# Ensure LAPS Configuration Policy is properly set

## Description

Windows LAPS (Local Administrator Password Solution) ensures that local administrator passwords are unique, randomly generated, and regularly rotated on managed devices. This check verifies that at least one Intune configuration policy exists for Windows LAPS.

## How to fix

1. Navigate to [Microsoft Intune admin center](https://intune.microsoft.com).
2. Click **Endpoint security** > **Account protection**.
3. Click **Create policy**.
4. Select **Windows 10 and later** as the platform.
5. Select **Local admin password solution (Windows LAPS)** as the profile type.
6. Configure the LAPS settings according to your organizational needs.
7. Assign the policy to the appropriate device groups.
8. Click **Create**.

## Learn more

* [Windows LAPS with Microsoft Intune](https://learn.microsoft.com/en-us/intune/intune-service/protect/windows-laps-overview)
