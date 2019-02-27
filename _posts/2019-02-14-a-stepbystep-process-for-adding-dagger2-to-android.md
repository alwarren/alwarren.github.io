---
layout: post
title: "Adding Dagger2 to Android"
author: al
categories: [ Android Studio ]
image: assets/images/kotlin-example-3.jpg
featured: false
hidden: false
source:
permalink: adding-dagger2-to-android
---
Dagger2 is a powerful dependency injection library. However, it can be confusing for the first-time user. And unless things are created in the correct order, builds fail with cryptic error messages.

I could never remember the order of the steps required to add Dagger to an android project. So I wrote a project from scratch to document the process.

**Project Setup**

<ol>
  <li>Setup Gradle version variables (optional)</li>
  <li>Setup Gradle dependencies</li>
  <li>Create an App class that extends Application</li>
  <li>Add Timber logger initialization to App.onCreate() (optional)</li>
  <li>Add App to manifest</li>
  <li>Create any classes that will be injected by Dagger2</li>
  <li>Create any classes that will @Inject objects using Dagger2 (use constructors but don't use @Inject yet)</li>
  <li>Add UI implementation</li>
  <li>Compile and run the code.</li>
</ol>

**Dagger Packages**

<ol start="10">
  <li>Create the following packages for Dagger2
    <ul>
        <li>di.builder</li>
        <li>di.component</li>
        <li>di.module</li>
    </ul>
  </li>
</ol>

**Dagger Modules**

<ol start="11">
    <li>Create AppModule.kt in di.module</li>
    <li>Create AppModule.kt in di.module</li>
</ol>

**Dagger Builders**

<ol start="13">
    <li>Create ActivityBuilder.kt in di.builder</li>
    <li>Create any other builders as needed</li>
</ol>

**Dagger Components**

<ol start="15">
    <li>Create AppComponent.kt in di.component</li>
</ol>

**Extend Activity class(es)**

<ol start="16">
    <li>MainActivity now extends DaggerAppCompatActivity</li>
</ol>

**Rebuild**

<ol start="17">
    <li>Rebuild the app</li>
</ol>

**Extend App class**

<ol start="18">
    <li>App now extends DaggerApplication</li>
    <li>Add required override for applicationInjector() (verify DaggerAppComponent exists at this point)</li>
</ol>

**Add Injections**

<ol start="20">
    <li>Add any constructor or object injections using @Inject</li>
    <li>Add any constructor or object injections using @Inject</li>
</ol>

**Rebuild**

<ol start="22">
    <li>Rebuild/run the app</li>
</ol>
