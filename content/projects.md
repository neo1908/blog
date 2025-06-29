---
layout: projects
summary: projects
title: Projects
---

Here is a collection of projects and toys I've made over the years.

## [Game of Life](https://game-of-life.st2projects.com/)

A basic game of life implementation using WebAssembly, Rust and Cloudflare Pages

## [SSH Sentinel](https://github.com/ST2Projects/ssh-sentinel-server)
A barebones SSH CA server.

I mostly used this to learn some Go but also because I couldn't find an SSH CA server that was simple to use.

I have this running on a Raspberry PI at home and it works great. There is an ansible role to configure sshd correctly and also created a [CLI app](https://github.com/ST2Projects/ssh-sentinel-server) so connecting to a server is as simple as `ssh <servername>`
    
## [SSH Sentinel RS](https://github.com/ST2Projects/ssh-sentinel-server)
A rust re-write of the Go version above. Progress on this is slow but I'm getting there!

The final version will be deployed / deployable on [Shuttle](https://shuttle.rs)

## [VizGraph](https://github.com/ST2Projects/vizgraph)
A web based interactive GraphViz viewer. The current version is a basic proof of concept. In time I'll be adding features like:
- Mark dependency as vulnerable - View the impact of a vulnerable dependency on your projects
- Project filtering - Filter a specific project and simplify the view
- Improved UI