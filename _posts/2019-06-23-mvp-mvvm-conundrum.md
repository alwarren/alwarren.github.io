---
layout: post
title:  "The MVP/MVVM Conundrum"
author: al
categories: [ Android, Developer ]
image: assets/images/android-binary.png
permalink: mvp-mvvm-conundrum
featured: true
hidden: true
---
So here's something I think about frequently. We hear so much about clean this clean that. Where does this go. Where does that go. Here's the thing. If it formats what the user sees, hears, or touches, it's the UI layer which is the outermost layer in clean architecture. If it alters data it's in the adapter layer which is the next level down.

So here's what really makes me think. If you have a presenter that both modifies the raw data using some mapper and tells the UI what to do, then how is that clean? Telling the view what to do means the presenter (adapter) has to know what the view can do. And that's crossing the boundary layer in the wrong direction. It doesn't matter that it's some interface. It's still aware of what the view is capable of doing. And so, architecturally, it can't be part of the adapter layer.

I tend to think of an Android ViewModel as a presenter. But I don't think that's correct. Traditionally, a view model is nothing more than a set of data needed for output along with whatever operations you need to reduce and/or format the data. Typically, though not always, it's a subset of some larger set of data. But the point is, you take some data and modify it in some way for output. The original intent of a view model was to separate output operations from the logic required to reduce and/or format the data. I don't have a lot of experience with MVC in the C world, but I did a lot of it while working with PHP/MySQL content management systems. A PHP script can turn into a huge mess when you start mixing logic and html in the same file. I got so tired of trying to decypher that stuff I started to write separate classes to reduce some of the noise so I could just feed the script some variables. I had a naming convention that used ViewModel in the class name. I had no idea at the time that it was actually a thing. It's just somthing I did during the refactoring cycle.

So how is the Android ViewModel different than the traditional view model? Here's what the developers say:

> "The ViewModel class is designed to store and manage UI-related data in a lifecycle conscious way. The ViewModel class allows data to survive configuration changes such as screen rotations."

And then they go on to say this:

> "UI controllers such as activities and fragments are primarily intended to display UI data, react to user actions, or handle operating system communication, such as permission requests. Requiring UI controllers to also be responsible for loading data from a database or network adds bloat to the class."

And then note this key phrase:

> "It's easier and more efficient to separate out view <u>data ownership</u> from <u>UI controller logic</u>."

And so, it seams, they key takeaway is that the ViewModel was never intended as a controller, presenter, or anything else beyond just a data object. Of course, objects can have methods but really all a ViewModel needs is some basic instructions for loading the data. In other words, it tells the view, "tell me what to store and I'll store if for you and take care of device rotation."

The magic of ViewModel really shines when you use it with LiveData. Now you have something you can observe for changes. And when that happens, you can just send things off to the affected views. Of course, if you have a really complex view system, you can always do the heavy lifting with a presenter.

So here's one of the conclusions I've been thinking about. Using an Android ViewModel "properly" doesn't really make your app MVVM. In my opinion, MVVM is not about the entire architecture. It's about the architecture of the UI layer. I think overall, an Android app is still MVC along with some additional layers such as view models, presenters, etc.

Just an opinion. Your mileage may vary.
