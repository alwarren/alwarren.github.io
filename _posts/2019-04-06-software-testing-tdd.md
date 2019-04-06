---
layout: post
title: "An Experiment in Test Driven Development"
author: al
categories: [ Developer ]
permalink: tdd-experiment
image: assets/images/software-testing.png
alt-image: assets/images/testing-pyramid.png
featured: true
hidden: true
description: "Make it work. Make it right. Make it fast."
---

> "_Make it work. Make it right. Make it fast._"

Recently, there was a discussion about test driven development on one of the [Slack](https://slack.com/) channels I frequent. So I decided to do a little experiment and post the results. What follows is that post.

---

Let's build a new class using test driven development (TDD). To do that, every time we create anything, we create the test first, let it fail, modify the code under test, then run all tests. We run all tests each time to catch any regression (errors in other tests caused by changes). Plus, we can keep using the same keyboard shortcut which saves us a few seconds compared to looking at the editor, finding the run icon, and clicking it.

One thing will come to mind. The rules say you always start with a failed test. But how do you write a test for something that doesn't exist? You write the test exactly as you would expect to see it if that something did exist. The build will fail (usually indicated in the IDE editor) and that counts as a failed test. You don't have to actually run the test at this point but if you want to you can just for consistency.

Why would we go to all that trouble? For a few reasons but, just from a very basic beginner's perspective, it forces us to think differently while writing the code under test. What's the difference? It forces you to think about validating behaviors first. And you can't validate anything without rules. So you write the rules first (the test). Tests become proof that your code follows the rules. It also forces you into a natural try/fail/correct/succeed progression which is actually very healthy.

The bigger takeaway is that, in the long run, it saves time. How does it save time? By building confidence. See here's the thing, we spend a lot of time staring at our code to makes sure it is what we think it is. Why do we even need to do that. Why not just run a test and see if it passes. If it passes, we move on. If not, we fix it, make the test pass, then move on. The more we do that, the more confident we become and the less time we spend staring and wondering.

**Time for an Example**

Here's a simple walkthrough of an example class I created with the following steps:

**Initial setup.**

1. Start in the test folder package that will contain a class you want to create.
2. Create the class but append Test to the name.
3. Create an empty test. I always start with one called nothing.
4. In the test method, create an instance of the class.
5. Run all tests (you only have one at this point).
6. The build fails (that counts as a failed test).

```
class MyClassTest {
    @Test
    fun nothing() {
        MyClass() // shows an error in the IDE
    }
}
```

**Make the initial test pass.**

1. Create the class with no constructor and no body.
The editor indicates the class exists (that counts as making a failed test pass).
2. Rename the nothing test method to something meaningful.
3. Run all tests (you only have one at this point).

```
class MyClassTest {
    @Test
    fun `object created`() {
        MyClass() // shows valid in the IDE
    }
}

class MyClass
```

**Modify the constructor**

1. Add a parameter to the constructor
2. Run all tests
3. The build fails (that counts as a failed test)

```
class MyClassTest {
    @Test
    fun `object created`() {
        MyClass() // shows an error in the IDE
    }
}

class MyClass(name: String)
```

**Make the test pass (do not modify the initial test).**

1. Add a secondary empty constructor that passes a value to the modified primary constructor.
2. Run all tests.

```
class MyClassTest {
    @Test
    fun `object created`() {
        MyClass() // shows valid in the IDE
    }
}

class MyClass(name: String) {
    constructor() : this("")
}
```

**Create a test for the new constructor**

1. Create a failing test for the modified constructor
2. Run all tests.
3. The build fails (that counts as a failed test).

```
@Test
fun `object created with argument`() {
    MyClass("")
}
```

**Make the test pass**

1. Because of the secondary constructor, we have to modify the failed test instead of creating a new one (we wouldn't normally do this).
2. Run all tests.

```
@Test
fun `object created with argument`() {
    MyClass("") // shows as valid in the IDE
}
```

**Create an object member**

1. Run all tests.
2. The build fails (that counts as a failed test).

```
@Test
fun `object has a member`() {
    val member: String = MyClass().member // shows an error in the IDE
}
```

**Make the test pass**

1. Create the object member
2. Run all tests.

```
class MyClass(name: String) {
    constructor() : this("")

    val member: String = name
}
```

**Here's the completed code:**

```
package com.my.project

import org.junit.Test

class MyClassTest {
    @Test
    fun `object created`() {
        MyClass() // shows valid
    }

    @Test
    fun `object created with argument`() {
        MyClass("")
    }

    @Test
    fun `object has a member`() {
        MyClass().member // shows valid in the IDE
    }
}

class MyClass(name: String) {
    constructor() : this("")

    val member: String = name
}
```

So that's a very simple example of the basics of TDD. Don't let the number of steps scare you. As you work through things, they happen fairly rapidly. And speed is one of the key advantages. But the key is to always write the test first. That's what makes it TDD.
