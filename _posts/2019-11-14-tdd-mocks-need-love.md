---
layout: post
title: "TDD Mocks Need Love Too"
author: al
categories: [ Developer ]
permalink: tdd-mocks-love
image: assets/images/software-testing.png
alt-image: assets/images/testing-pyramid.png
featured: true
hidden: true
description: "TDD Mocks Need Love Too."
---

> "_Make it work. Make it right. Make it fast._"

When using test driven development, sometimes you just need to mock something. Such was the case recently while playing with a weather API. It's fairly early
on in development at this point with really just an entity based on a JSON
response from the server that [looks something like this](https://samples.openweathermap.org/data/2.5/weather?q=London&appid=b1b15e88fa797225412429c1c50c122a1).

It occurred to me that sooner or later a view class from the object might be in
order. And, of course, we want to test that class, right? But we really don't
want to go to all the trouble of doing an actual call to the server in our test.
Tests are supposed to be fast. So I stuffed a json response into a text
file to use every time we create the mock.

If we're using a mock in testing, we expect the values to remain constant. We
sure don't want some test to fail because we changed a value in the mock.
So how do we prevent that? We test the mock. And every time we run test we run them all. If a value in the mock changes we'll catch it.

And without further ado, here's the completed test suite:
<br />*(Using JUnit5 with some fancy stuff to get the log output)*

```
class CurrentWeatherMockTest : UnitTest() {
    lateinit var actual: CurrentWeather

    @BeforeAll
    override fun beforeAll() {
        actual = Gson().fromJson(CurrentWeatherMock.json, CurrentWeather::class.java)
        println(Values.suiteTitle(Values.SUITE_TITLE_WEATHER_MOCK_CURRENT_WEATHER))
    }

    @Nested
    @DisplayName("API")
    @TestMethodOrder(MethodOrderer.OrderAnnotation::class)
    @TestInstance(TestInstance.Lifecycle.PER_CLASS)
    inner class Api {
        @BeforeAll
        fun setup() {
            println(Values.classTitle("API"))
        }

        @Order(1)
        @Test fun `expected methods`() {
            print(Values.testTitle("expected methods"))
            actualMethods() shouldEqual expectedMethods()
            showPassed()
        }
    }

    @Nested
    @DisplayName("Behavior")
    @TestMethodOrder(MethodOrderer.OrderAnnotation::class)
    @TestInstance(TestInstance.Lifecycle.PER_CLASS)
    inner class Behavior {
        @BeforeAll
        fun setup() {
            println(Values.classTitle("Behavior"))
        }

        @Test
        @Order(1)
        fun `coord values are correct`() {
            print(Values.testTitle("coord values are correct"))
            actual.coord?.lon shouldEqual -96.8
            actual.coord?.lat shouldEqual 32.78
            showPassed()
        }

        @Test
        @Order(2)
        fun `weather values are correct`() {
            print(Values.testTitle("weather values are correct"))

            val weather = actual.weather?.get(0)
            weather?.id shouldEqual 800
            weather?.main shouldEqual "Clear"
            weather?.icon shouldEqual "01n"

            showPassed()
        }

        @Test
        @Order(3)
        fun `main values are correct`() {
            print(Values.testTitle("main values are correct"))

            val main = actual.main
            main?.temp shouldEqual 269.51
            main?.pressure shouldEqual 1026
            main?.tempMin shouldEqual 266.48
            main?.tempMax shouldEqual 271.48

            showPassed()
        }

        @Test
        @Order(4)
        fun `wind values are correct`() {
            print(Values.testTitle("wind values are correct"))

            val wind = actual.wind
            wind?.speed shouldEqual 1.5
            wind?.deg shouldEqual 140

            showPassed()
        }

        @Test
        @Order(5)
        fun `clouds values are correct`() {
            print(Values.testTitle("clouds values are correct"))

            val clouds = actual.clouds
            clouds?.all shouldEqual 1

            showPassed()
        }

        @Test
        @Order(6)
        fun `sys values are correct`() {
            print(Values.testTitle("sys values are correct"))

            val sys = actual.sys
            sys?.type shouldEqual 1
            sys?.id shouldEqual 4193
            sys?.country shouldEqual "US"
            sys?.sunrise shouldEqual 1573649968
            sys?.sunset shouldEqual 1573687899

            showPassed()
        }

        @Test
        @Order(99)
        fun `current weather values are correct`() {
            print(Values.testTitle("current weather values are correct"))

            actual.base shouldEqual "stations"
            actual.visibility shouldEqual 16093
            actual.dt shouldEqual 1573647508
            actual.timezone shouldEqual -21600
            actual.id shouldEqual 4684888
            actual.name shouldEqual "Dallas"
            actual.cod shouldEqual 200

            showPassed()
        }
    }

    @Nested
    @DisplayName("Corner Cases")
    @TestMethodOrder(MethodOrderer.OrderAnnotation::class)
    @TestInstance(TestInstance.Lifecycle.PER_CLASS)
    inner class CornerCases {
        @BeforeAll
        fun setup() {
            println(Values.classTitle("Corner Cases"))
        }

        @Test
        @Order(1)
        fun `no tests`() {
            noTests()
        }
    }

    override fun actualMethods(): List<String> {
        return MethodSpy.publicMethodNames(CurrentWeatherMock::class.java)
    }

    override fun expectedMethods(): List<String> {
        return emptyList()
    }

}
```

And here's the log output:

```
Current Weather Mock Test Suite 2019-11-14 10:06 AM
  API
    expected methods => PASSED
  Behavior
    coord values are correct => PASSED
    weather values are correct => PASSED
    main values are correct => PASSED
    wind values are correct => PASSED
    clouds values are correct => PASSED
    sys values are correct => PASSED
    current weather values are correct => PASSED
  Corner Cases
    No Tests
End of Test Suite
Passed 8 of 8 tests
```

Why did I go to all this trouble? I have no idea really. Something to do I suppose. Maybe it's useful. Maybe it's not. I'll leave that up to you to decide.
