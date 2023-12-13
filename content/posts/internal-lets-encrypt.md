---
date: "2022-01-19T10:37:53Z"
draft: false
tags:
- certificates
- ssl
- tls
- let's encrypt
- infrastructure
title: Internal Lets Encrypt
---

# Internal Let's Encrypt Certificates

Here are some thoughts and ideas on how I have lets encrypt certificates deployed to home _infrastructure_ ...

At a high level , my setup assigns a hostname based subdomain for each internal host.

E.G. If my registered domain is `example.com` and my host is `host1` then I will generate a cert for `host1.example.com`.

Let's encrypt supports wildcards, you could use a wildcard if you wanted to. I didn't like the idea of every internal host using the same keypair.

The "external" domain has no DNS records attached to it. I add a record for each host in pihole. That way, all my hostnames stay private.

I used cloudflare for my registrar, you can use something different but you're on your own in terms of instructions.

## High Level Steps / Pre-requisites

- You'll need to own a domain with a proper Registrar. Cloudflare is good but any registrar supported by certbot is fine
- Generate an API key that will allow you / certbot to add / remove DNS records remotely. [Cloudflare guide](https://support.cloudflare.com/hc/en-us/articles/200167836-Managing-API-Tokens-and-Keys)
- Install certbot using their [instructions](https://certbot.eff.org/instructions) as a guide. Make sure you also have the correct authenticator plugin installed
- Certificates are genrated on a single machine. Ansible is used to deploy certs to their target hosts. I find this makes it easier to manage and automate.

## Create a cert

Having installed certbot, create a file called `.cloudflare_dns` on your "cert controller" and put your registrar API key in there.

```
# Cloudflare API token used by Certbot
dns_cloudflare_api_token = 0123456789abcdef0123456789abcdef01234567
```

Now you can generate a cert:

```bash
certbot certonly --dns-cloudflare --dns-cloudflare-credentials .cloudflare_dns -d host1.example.com  --key-type ecdsa
```

I've been using ECDSA keys wherever I can. The key size is smaller but they are more secure than RSA. If you need RSA keys for some reason just drop the `--key-type` argument.

You should now have a new keypair in `/etc/letsencrypt/live/host1.example.com`. You'll want the `fullchain.pem` and `privkey.pem` files.

### Unifi Controllers

I use Ubiquiti kit for my home networking and also have a couple of their security cameras. These are all driven by a CloudKey Gen 2 which acts as the central hub for configuration. I also have a Let's Encrypt cert deployed there to get rid of the nasty SSL warning the default cert gives you.

The steps to deploy the cert are pretty simple, first login to your controller and then:

Change to the unifi-core config directory

```bash
 cd /data/unifi-core/config
```

In this directory, you'll find a couple of files, you're interested in `unifi-core.crt` and `unifi-core.key`. **Backup the origionals** then copy your `fullchain.pem` and `privkey.pem` files from Let's encrypt into this directory and rename them:

```bash
cp /tmp/fullchain.pem /data/unifi-core/config/unifi-core.crt
cp /tmp/privkey.pem /data/unifi-core/config/unifi-core.key
```

## Next steps

- Think about [automated renewal](https://eff-certbot.readthedocs.io/en/stable/using.html?highlight=renew#setting-up-automated-renewal)
- Think about automation. Jeff Geerling has a good [ansible-galaxy module](https://github.com/geerlingguy/ansible-role-certbot) that deals with certbot
- Configure your webservers properly . Mozilla has a [good tool](https://ssl-config.mozilla.org/) to help you . Seeing as everything is internal - you should be able to use the most modern options and even limit to TLS1.3 only.
- If you're really nerdy, consider Certificate Transparency monitoring. This will alert you when new certs are generated for your domain. Cloudflare has an option to do this.

## Automation setup

I've started to use [ansible-semaphore](https://ansible-semaphore.com/) to manage my playbooks. It's pretty simple to setup and use. I have an ansible script that will generate and deploy certs automatically. It runs once a day at about 2AM

The idea is to have TLS / SSL on as much as possible but to not have to think about it - everything should be as automated. 

## Last bits 

Depending on howfar you want to go, it is probably good to have some monitoring in place for your internal services. I use [nagios](https://www.nagios.org/) and [NetData](https://www.netdata.cloud/agent).

NetData is awesome, it provides more metrics than I know what to do with.

It's also nice to have one place you can go to access everything . I use [homer](https://github.com/bastienwirtz/homer) for this. The setup is really nice - just a yaml file and a lovely dashboard is created for you:

![image](https://user-images.githubusercontent.com/20709030/141301959-cf8e51f0-a09d-4233-ad23-0a878d871d8b.png)

