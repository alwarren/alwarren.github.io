---
layout: post
title: "Cartesian Confusion"
author: al
categories: [ Developer ]
permalink: cartesian-confusion
image: assets/images/cartesian.png
alt-image: assets/images/cartesian-triangle.png
featured: true
hidden: true
description: "Think differently. Think Cartesian"
---
I was working on a fun Java project the other day. Part of the project involved moving values in a two-dimensional array. The code for that seemed pretty straight forward. But I kept getting the wrong result. I finally got it to work but when I looked at the code, it made absolutely no sense.

Here's a simple example.

Consider the following values:

```
8  1  3
4  0  2
7  6  5
```
1. Store the values in a two-dimensional array of int.
2. Move the 0 up by modifying a single index and swapping two values.
3. Print the result.

```
8  0  3
4  1  2
7  6  5
```
Seems simple enough, right? Well, things are not always as they seem. Things were moving around alright. But in a bizarre fashion that made no sense. What's worse, the code that eventually worked made no sense either. What in the world was going on.

As it turns out, there is an important distinction between thinking in Cartesian space and working with two-dimensional arrays. That may be old news to you. But either I never knew that or had totally forgotten about it. And then I stumbled upon a link that explained things. It would have been nice to have known that before spending so much time hacking at the code just to "get it right". It's nice to make things work. But not so nice when you don't understand why the very code you wrote actually works.

In the end, sometimes you just have to look at things differently.

> Approach life with a sense of wonder and discovery. Evolve your mind. Let it grow. Keep learning. And you will never grow old.
