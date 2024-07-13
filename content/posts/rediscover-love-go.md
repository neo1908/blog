---
title: "Rediscovering My Love Of Programming... With Go"
date: 2024-07-10T21:30:35+01:00
draft: true
tags:
 - Development
 - Go
---

## Falling out of love
I work on a mostly legacy codebase, this means there's more cruft and weirdness than you can shake a large stick at. Oh and it's Java, so that's *enterprise* cruft and weirdness.
<br/>
You want to add a parameter to some config? You fool! That's 16 classes each with 3 overloaded constructors you need to edit... Now as it turns out I don't feel like I actually *do* that much development these days but if anything that's part of the problem.
In the not too distant past I used to run home or, during The Event, remain at home and spend another few hours messing around in code or other code adjasent activity.
<br/>
I've always enjoyed learning new languages. I enjoy seeing the same problems solved in different ways and trying new ways of doing things. You wouldn't believe how many dead side-projects I have... double the number you're thinking of.
<br/>
Don't get me wrong, I'm not blaming work for my situation. I enjoy my job ( that's what I keep telling myself anyway ) and I find it mostly rewarding. Ultimately I think I'm bored and Iv'e been struggling to get back on the horse.
<br/>
There's one thing I've noticed though, of all the dead side-projects and toys I've written, I keep coming back to one and that's the [SSH CA Server](https://github.com/ST2Projects/ssh-sentinel-server) I started a while back in Go.

## The Go Journey

Go just seemed to click for me as I picked it up. Don't get me wrong, it's not perfect... having the curly braces on the wrong line is a serious issue for sure but the language's simplicity is a big win.
<br/>
Over time I've also come to appreciate the lack of try-catch as well. Try-catch is of course a major part of exception handling in Java and many other languages so losing that took some time to internalise. Treating errors as values does make a lot of sense once you start writing code and thinking about handling errors. Sure it can get a bit messy with lots of `if err != nil` but it's obvious where the errors are coming from and helps to [reduce code nesting](https://www.youtube.com/watch?v=CFRhGnuXG-4)
```go
someVar, err := funcThatReturnsAnError()

if err != nil {
    // Do something to handle the error
}

continueOnHappyPath(someVar)
```

Instead of:

```Java
try
{
    var someVar = funcThatThrowsException();
    continueOnHappyPath(someVar)
}
catch(Exception e)
{
    // Do something to handle the error
}
```

And it's not just the code styling either. I've really grown to enjoy the default tooling. Basically anything other than a Hello World in Java requires a 3rd party build tool like Maven or Gradle. It's all provided for you in Go though.

`go.mod` is quite terse but it's XML free and fairly straight forward to work with

> XML combines the efficiency of text files with the readability of binary files
    - Unknown

`go build` will build your binary for you... much easier than configuring maven plugins etc.
<br/>
I could go on at some length about other things I much prefer in go land... maybe I will another time.
<br/>
All of this is to say that go has returned my love of programming, several nights a week I get the itch to sit down and code... much to the irritation of my girlfriend.

### The re-write
So what's next? Well at the moment I'm still working on the SSH CA, I want some more features and I'm in the enviable position of being the only person that uses and develops it so if I want it I'll get it!
<br/>
Currently this means porting it to [PocketBase](https://pocketbase.io/) I'm learning lots and having fun, it's a dream come true!
