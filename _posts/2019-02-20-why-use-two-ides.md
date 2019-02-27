---
layout: post
title: "Why Use Two IDEs?"
author: al
categories: [ Android Studio ]
image: assets/images/choices.jpg
featured: true
permalink: why-use-two-ides
---
[Android Studio](https://developer.android.com/studio/) is a great IDE. And so is [IntelliJ](https://www.jetbrains.com/idea/). But why use IntelliJ for developing [Android Apps](https://www.android.com/) if we can't do any Android related things? And, that, my friend, is exactly why I use both. Let me explain.

The following bit of code from [Retrofit and Coroutines]({{ site.baseurl }}{% post_url 2019-02-14-retrofit-and-coroutines %}) is from an Android app I'm working on:

```Kotlin
interface ApiRequest {
    fun <T, R> requestFromApi(call: Call<T>, transform: (T) -> R, default: T): Either<Failure, R> {
        return try {
            val response = call.execute()
            when (response.isSuccessful) {
                true -> Either.Right(transform(response.body() ?: default))
                false -> Either.Left(Failure.ServerError)
            }
        } catch (exception: Throwable) {
            exception.printStackTrace()
            Either.Left(Failure.ServerError)
        }
    }
}
```

The repository extends `ApiRequest` so I can do something like this: `requestFromApi(...)`. So what's the big deal you say and what's that have to do with IntelliJ? For the same reason I mentioned at the beginning of the post - [IntelliJ](https://www.jetbrains.com/idea/) can't do [Android](https://www.android.com/) things. It's just a dumb stand-alone IDE.

### Clean Architecture

So what makes using [IntelliJ](https://www.jetbrains.com/idea/) important in my development lifecycle? [Clean Architecture](https://fernandocejas.com/2018/05/07/architecting-android-reloaded/) and [Separation of Concerns](https://en.wikipedia.org/wiki/Separation_of_concerns). It forces me to do both of those because, not only am I not tempted to, I actually can't use Android things.

The code in the aforementioned article was all initially developed in a plain [Kotlin](https://kotlinlang.org/) project in IntelliJ. And here's why. If it runs, compiles, and tests in Intellij, I can be assured that it will do the same in [Android Studio](https://developer.android.com/studio/) without any Android or project related dependencies.

[IntelliJ](https://www.jetbrains.com/idea/) is my go to for initial Android development. As long as the package names are the same, when the code is ready to move to Android, all I have to do is copy the file over to the same package in the [Android Studio](https://developer.android.com/studio/) project and it just works.

### Best of Both Worlds

Stand alone [IntelliJ](https://www.jetbrains.com/idea/) projects have become a great tool. I actually prefer it for initial development over [Android Studio](https://developer.android.com/studio/) because it keeps a lot of the noise down.

If you're not already using both [IntelliJ](https://www.jetbrains.com/idea/) standalone and [Android Studio](https://developer.android.com/studio/), give it a try. You might like it.
