---
title: "A practical guide to avoid unhandled promise rejection DeprecationWarnings in Node"
date: 2018-06-07
---

This article was published on [medium](https://medium.com/@kyle.mickey/a-practical-guide-to-avoid-unhandled-promise-rejection-deprecationwarnings-in-node-f9c67634dd2b).

Even experienced developers sometimes miss subtle, but important, points regarding promises and unhandled rejections.

Let’s say you’re working on a RESTful (ish?) API. You’ve just spent the last few hours writing a whole bunch of business logic, you have controllers calling services, and services calling repositories or data models, getting all asynchronous up in here. Everything’s humming along perfectly, until suddenly your endpoint doesn’t respond and times out. You check the logs or console outputs, and you see: `(node:127) [DEP0018] DeprecationWarning: Unhandled promise rejections are deprecated. In the future, promise rejections that are not handled will terminate the Node.js process with a non-zero exit code.`

<div class="flex-wrapper">
    <iframe align-self="center" src="https://giphy.com/embed/ReImZejkBnqYU" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/angry-computer-frustrated-ReImZejkBnqYU"></a></p>
</div>

But you were so careful! So what happened here!? Let’s take a look.

### Nested Promises

Here we have promises that get some values, then make additional promises.

<div class="iframely-embed"><div class="iframely-responsive" style="padding-bottom: 100%;"><a href="https://gist.github.com/BadAsstronaut/d4d30960f1beafdcc55c7bebf201e0a0" data-iframely-url="//cdn.iframe.ly/hlEHzcj"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>


The promise on line 4 to `getUserInfo` never gets caught! Nested promises do not get caught automatically, so you need a catch block for every promise chain!

### Abusing Async/Await and Try/Catch

Async/await in JS is pretty new, but under the hood ‘await’ is still just a promise! And, just like in the example above, each awaited promise needs to be handled and caught. While you can wrap multiple async calls in a single try/catch block, it’s important to make sure that the awaited functions either resolve or reject.

<div class="iframely-embed"><div class="iframely-responsive" style="padding-bottom: 100%;"><a href="https://gist.github.com/BadAsstronaut/70a879fe3aca51d89b2b69ea22107e17" data-iframely-url="//cdn.iframe.ly/HgjYPoq"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

### Defensive Techniques

As we saw in the first example, a promise that does not resolve or reject does not get handled. Unhandled rejections are bad. This whole issue can be avoided by always returning your promises!

<div class="iframely-embed"><div class="iframely-responsive" style="padding-bottom: 100%;"><a href="https://gist.github.com/BadAsstronaut/9d135ec31936d7efc303fe588692fb30" data-iframely-url="//cdn.iframe.ly/dy2g22x"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

Note that we are only using one promise chain!

Sometimes, you may need additional parameters from outside the promise chain. This can be elegantly handled by currying your functions!

<div class="iframely-embed"><div class="iframely-responsive" style="padding-bottom: 100%;"><a href="https://gist.github.com/BadAsstronaut/422e43654eed9476b181aae6cc43f401" data-iframely-url="//cdn.iframe.ly/i4Cvy1O"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

### Conclusion

In the near future, node.js will terminate and exit on unhandled promise rejections. I recently watched Ryan Dahl (creator of node) discussing 10 things he regrets about node, and he said something about how obvious it is that an application should terminate when a promise rejection is unhandled.

So, let’s keep our promises and handle rejection well!