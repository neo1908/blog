#!/usr/bin/env just --justfile

run:
    npm ci
    npm run render
    hugo server -D --buildDrafts

render:
    npm run render

build:
    hugo
