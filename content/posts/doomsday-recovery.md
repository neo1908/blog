---
title: "Doomsday Recovery"
date: 2022-01-19T10:46:50Z
draft: false
tags:
 - backups
 - recovery
 - 2fa
---

# Doomsday Recovery

This page serves as a dumping ground for ideas on preserving access to online ( and offline ) accounts in the event of disaster

## General Principles

* All passwords are stored in a password safe ( KeePass )
* Password safe lives on the NAS and is backed up once per day to a spare nas
* primary NAS is backed up once per week to B2 Storage


### TODOs

- [x] Consider a way to ensure access with TOTP codes
- [x] Ensure duplicate yubikeys are used
- [ ] Automate as much as possible
- [ ] Document
- [ ] Practice

## TOTP and 2FA

It's good practice to enable and use 2FA whenever the platform you're using offers it ( if they don't then ask them why! ). Any 2FA is better than no 2FA, but it's a good idea to avoid SMS based tokens, there have been a few high profile victims of sim-jacking and it's not that hard to do... That's not to say that other 2FA methods are foolproof... you can still phish for hardware tokens after all.

I like YubiKeys for this purpose, they are small and almost indestructible ( apart from my last one who died yesterday ☹️  ) and are a physical second factor as opposed to a text message. I need the yubikey **with me** to use it. The vast majority of websites / platforms that support 2FA will support TOTP codes ( Timebased One Time Passwords ) and setup is normally straight forward:

* Download the Yubikey Authenticator app
* Plug in your yubikey
* Scan the QR code the website is showing you
* Provide the code the app now gives you to prove everyone is happy

But what if I lose my yubikey?

### Losing your yubikey

Don't lose your yubikey, it's just easier if you don't lose it.

### Surviving a lost yubikey

You can't clone YubiKeys ( that's kind of the point ) so any backups we make need to made at creation time rather than after. The process I've come up with is this:

* Enable 2FA on the target account
* Don't scan the QR code, but copy the secret key ( you might need to click "I can't scan the code" or something like that )
* Save the secret key in a plaintext file **offline**
* Configure your yubikey and any backups with the copied secret key ( or you can scan the qr code now )

This way, if we ever lose the yubikey we have a) a backup yubikey and b) the secret key to configure future keys if we need to

Saving the secret key does introduce some level of risk of course... It needs to stay **secret** the clue is in the name. At the moment, this plaintext file lives on a USB stick.

It would be nice to encrypt our copy of the secret keys so that idle snoopers can't clone them, naturally this introduces the problem of manging that encryption key... It's a work in progress

------

At this point we should be good in the event of disaster. This process isn't perfect and is more manual than I would prefer, but that can always be worked on and refined.
