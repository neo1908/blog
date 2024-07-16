---
title: "Migrating to Github"
date: 2024-07-16T18:57:08+01:00
draft: true
tags:
  - cloudflare
  - meta
---

I have a major problem - I use too many git services. I have projects on github, gitlab, an internally hosted gitea instance and just the other day I thought about checking out [forgejo](https://forgejo.org).

For the most part this is "ok" in that as a serial side-project abandoner I'm not dealing with all these at the same time... however I've decided to get my life together and make a decision

## The Decision

Moving forward, github will be my primary service.

Why github? Well for several reasons:
- It works ( all of them do so this isn't a good one )
- I quite like the workflows
- My [active side project](https://github.com/ST2Projects/ssh-sentinel-server) is there
- I prefer the UI to gitlab

And let's face it, this "blog" is just turning into an excuse to do [light infrastructure stuff]({{<ref "cloudflare-worker-proxy.md">}})

## Let's do it

First step is to create a new repo in github, this is pretty straightforward

![](/new_blog_repo.png)

With that created, I can change my repo's origin url

```shell
git remote set-url origin git@github.com:neo1908/blog.git
```

And while we're at it let's rename the repo locally as well. This isn't strictly required but I prefer the local repo names to match the names on the remote

```shell
mv pages blog
```

We can then push and make sure everything goes where we expect

```shell
git push
```

Now we need to configure the github side. In our new repo I can go to `Settings` and then pages

![](/new_pages_config.png)

I'm going to deploy using github actions, [specifically hugo](https://github.com/neo1908/blog/blob/main/.github/workflows/hugo.yml), so I selected that as my source.

Before configuring a custom domain I need to update the DNS in cloudflare. Github automatically prefixes apex domains with `www` which is a bit irritating...  The github pages docs suggest configuring DNS for both `www` and the apex so that's what I'll do.

First I need to delete the old gitlab DNS. I could have just edited it, but I deleted it instead because I could. At this point the monitoring alerted. 
<br/>
Yes I [monitor this page](https://stats.uptimerobot.com/llM2NuOXyX/795915947)...

![](/status_page.png)

Now configure `www`
```dns
www.st2projects.com.	1	IN	CNAME	neo1908.github.io.
```
And now the apex
```dns
www.st2projects.com.	1	IN	CNAME	st2projects.com.
```

With that complete we can go and get a drink. Cloudflare DNS propagation is pretty fast, but I find waiting a few moments to be very reliable.
<br/>
![](/a_few_moments.png)
<br/>

Welcome back... Now we can go and at `st2projects.com` as the custom URL of the page. Once the DNS check is completed it's time to publish the page.

## Publishing

We need to add the workflow to publish the site, it's quite long so here's [a link](https://github.com/neo1908/blog/blob/main/.github/workflows/hugo.yml). Just like the gitlab version it's set up to run on pushes to the `main` branch.

With this added we can do the usual git magic
```shell
git add .github/
git rm .gitlab-ci.yml

git commit -m "Migrate to github"
git push
```

And all being well the workflow will trigger

![](/github_workflow.png)

Success! So if you're reading this, it's all worked out just fine. Catch me next week when I decide to migrate somewhere else...