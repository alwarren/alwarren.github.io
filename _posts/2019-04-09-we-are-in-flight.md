---
layout: post
title: "Exploring Sealed Classes"
author: al
categories: [ Android ]
permalink: we-are-in-flight
image: assets/images/binary.png
featured: true
hidden: true
description: "Exploring sealed classes in an Android application"
---
> "_Please fasten your seatbelts and return your tray table to its full upright and locked position._"

Recently there was some discussion about how to handle errors when making an http request. There was a suggestion to use a response object that contains either the data we expected or an exception. But what does an exception give us? Something to throw. And what happens when we throw it? The application crashes with an error message. Not exactly what we want to present to the user. What we really want to do is "_tell_" the user what happened in some meaningful way and then allow the application to continue so the user can decide what to do next.

One thing we can do is create an object that represents the types of errors you might get. Maybe something like this:

```
sealed class Failure {
    object NetworkConnection: Failure()
    object ServerError: Failure()
    object PermissionError: Failure()
}
```

Then instead of writing a bunch of code to create some custom exception to handle later, we describe it semantically where it occurs, send it back through our response object, and let the UI handle it however it wants.

Not long ago, I was thinking about what else we could do with a sealed class. It occurred to me that it might be a nice fit for handling something like a loading indicator. So I came up with this:

```
sealed class State {
    object InFlight: State()
    object Complete: State()
    object Idle: State()
    object Gone: State()
}
```

We use it to semantically describe the expected states of some process we're waiting on. So how do we use it? We store it in an observable and when it changes, we react to changes in the observable. Specifically, we can use it in an Android ViewModel to control a loading indicator.

So here's something really interesting. Today I was reading a post about coroutines written by Roman Elizarov. Roman is the Team Lead for Kotlin libraries. In the post, someone asked how we could monitor the state of a coroutine. In part, he replied with:

> "_...`launch` function returns a `Job`. You can keep a reference to it and check its `isActive` property..._" <sup>[1](#references)</sup>

He showed an example then went on to say this:

> "_A larger application would usually define [a] `loadingData` property in some base class of its view models (or whatever else — depending on the architecture) and provide some convenience function to set and reset it._" <sup>[1](#references)</sup>

Wow, in my "_experiments_", I had already done exactly that.

```
abstract class BaseViewModel : ViewModel() {

    private val _failure: MutableLiveData<Failure> = MutableLiveData()
    val failure: LiveData<Failure>
        get() = _failure

    private val _state = MutableLiveData<State>()
    val state: LiveData<State>
        get() = _state

    protected fun handleFailure(failure: Failure) {
        _failure.value = failure
        setCompletedState()
    }

    protected fun setInFlightState() {
        _state.value = InFlight
    }

    protected fun setCompletedState() {
        _state.value = Complete
    }

    private fun setGoneState() {
        _state.value = Gone
    }

    fun setIdleState() {
        _state.value = Idle
    }

    override fun onCleared() {
        setGoneState()
        super.onCleared()
    }
}
```

And then in the fragment:

```
private fun handleState(state: State?) {
    when(state) {
        InFlight -> {
            swipeRefresh.isRefreshing = true
        }
        Complete, Idle, Gone -> {
            swipeRefresh.isRefreshing = false
        }
        else -> { swipeRefresh.isRefreshing = false }
    }
}
```

Mind blown. Roman Elizarov had just validated the "_experiment_". It was a quite humbling discovery. Sometimes you just have to experiment. And sometimes it works.

### References <a name="references"/>

<sup>1</sup>  &nbsp;[https://medium.com/@nglauber/this-could-be-a-silly-question-but-how-can-i-know-if-a-coroutine-is-currently-running-ebdf218ae01](https://medium.com/@nglauber/this-could-be-a-silly-question-but-how-can-i-know-if-a-coroutine-is-currently-running-ebdf218ae01)  
