---
title: "Cloudflare Worker Proxy"
date: 2023-12-13T18:15:56Z
draft: false
tags:
- Cloudflare
- Development
- infrastructure
---

I recently decided to move this site from `https://blog.st2projects.com` to `https://st2projects.com` but I still wanted the blog url to redirect to the new location.
<br/>
This was easier than I thought seeing as this site is hosted on [Gitlab Pages](https://docs.gitlab.com/ee/user/project/pages/).

## Updating Gitlab Pages

First of all, I needed to re-configure my site on Gitlab to be served from the new URL.

![](/gitlab-pages.png)

Part of this process is adding the DNS records shown so at the same time I deleted the `blog.st2projects.com` record as it's not needed any more.

## Updating Hugo Config

The [hugo.yml](https://gitlab.com/st2projects/pages/-/blob/main/hugo.yml) config file includes the `baseURL` parameter which also needs updating to `https://st2projects.com`

```yaml
baseURL: https://st2projects.com
languageCode: en-us
title: ST2 Projects
theme: "PaperMod"
...
```

I can then redeploy the site to pick up the new config. This is as simple as a git commit and a push

```shell
git commit -am "Migrate site to new url"
git push
```

The gitlab CI will build and deploy the site for me... it's awesome

![](/gitlab-pages-pipeline.png)

## Proxies

Ok, so now we have moved to the new URL but I still want the old site to redirect.
<br/>
At first I thought it'd be as simple as adding a CNAME record. That _should_ work but seeing as I'm relying on gitlab / Let's Encrypt for my certificates I decided against it just incase they stop including wildcards in the Subject Alternative Name list.

The better _and more flexible_ approach is to use a HTTP 301 redirect to redirect requsts to the correct place. Doing it this way means I can be selective over what gets redirected and more importantly it means I can play with [Cloudflare Workers](https://workers.cloudflare.com/)

### Workers

So what are workers?
<br/>
The Workers [website](https://workers.cloudflare.com/) has it's own explanation but it's clearly been written by a marketing exec... In short, Workers are code that executes on Cloudflare's edge.

They have access to the full request and response objects and can augment both of them. It makes it super easy to add new headers to existing routes, adapt existing APIs or do literally anything you want.
<br/>
For my first forray we'll simply be responding with a 301 Redirect to any requests to `https://blog.st2projects.com`.

First of all then we need to create our new Worker. In cloudflare, this is as simple as creating a new Application and following the prompt

![](/cf-workers-setup.png)

From there we can use the `Quick Edit` option to replace the default Hello World content with our Worker code which is as simple as:

```js
export default {
    async fetch(request) {
        const destinationURL = "https://st2projects.com";
        const statusCode = 301;
        return Response.redirect(destinationURL, statusCode);
    },
};
```

We can then `Save and Deploy` to update our worker.
<br/>
With the worker created we need to assign it to our route. This took me a moment to find but it's under `Workers Routes` under the actual st2projects site.
<br/>
Simpley add a new route. The `route` will be URL that when hit will cause our Worker to execute so we want `blog.st2projects.com/*`. From the worker drop down we can select our new worker

![](/cf-worker-routes.png)

With that done our work is complete! No need to wait around for DNS propagation... The worker is deployed instantly and providing we got everything right our redirect is now in place. Testing and looking at the firefox dev tools...

![](/cf-worker-test.png)

Success!