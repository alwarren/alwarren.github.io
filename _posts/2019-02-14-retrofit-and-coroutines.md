---
layout: post
title: "Retrofit and Coroutines"
author: al
categories: [ Android Studio ]
image: assets/images/kotlin-example-3.jpg
featured: false
permalink: retrofit-and-coroutines
---
I was thinking about enqueue vs execute in Retrofit. One does it's own threading and the other just calls the api. So if I want coroutines to do the threading, why do I need to let Retrofit do it with enqueue? Here's what I came up with.

Modeled on Fernando Cejas's example of MVVM clean architecture for Kotlin, it uses a number of his ideas and code including his Either monad, an abstract UseCase where we use coroutines, and a few other Android specific bells and whistles.

Starting with retrofit, I have a builder object I use for injecting the service into the repository.

```Kotlin
object Api {
    private const val endpoint = "https://api.spacexdata.com/v3/"
    private val converter = GsonConverterFactory.create()

    fun <T> service(clazz: Class<T>) : T =
        Retrofit.Builder()
            .baseUrl(endpoint)
            .addConverterFactory(converter)
            .build().create(clazz)
}
```

I'm not doing anything special with Retroit so I decided to just use the Gson converter.

Then I have an interface for the request. The call to requestFromApi gives me some options. The first parameter is just the call, the second allows me to transform the data, and the third is a default value to return if the response body is null. Error handling is simplistic. I don't care about error responses. Either we get data for display or we don't so I just return a generic server error. If I wanted to do logging I'd do it a bit differently.

```Kotlin
interface ApiRequest {
    fun <T, R> requestFromApi(
        call: Call<T>,
        transform: (T) -> R,
        default: T
    ) : Either<Failure, R> =
        try {
            val response = call.execute()
            when (response.isSuccessful) {
                true -> Either.Right(transform(response.body() ?: default))
                false -> Either.Left(Failure.ServerError)
            }
        } catch (exception: Throwable) {
            Either.Left(Failure.ServerError)
        }
}
```

The repository is pretty straight forward. I'm not doing local storage because it's just an example so we just use the api.

```Kotlin
interface MissionRepository : ApiRequest {
    fun missions(): Either<Failure, List<Mission>>

    class Network(
        private val networkHandler: NetworkHandler,
        private val service: MissionService
    ) : MissionRepository {

        override fun missions(): Either<Failure, List<Mission>> =
            when(networkHandler.isConnected) {
                true -> requestFromApi(
                    service.getAll(),
                    { it -> it.map { it } },
                    emptyList()
                )
                false -> Left(Failure.NetworkConnection)
            }
        }
}
```

This is the UseCase where we use a coroutines suspending function.

```Kotlin
class GetMissions(private val repository: MissionRepository)
    : UseCase<List<Mission>, UseCase.None>() {

    override suspend fun run(params: None) = repository.missions()
}
```

And here is the abstract UseCase where the coroutines magic happens,.

```Kotlin
abstract class UseCase<out Type, in Params> where Type : Any{
    private val mainJob = Job()
    private val uiScope = CoroutineScope(Dispatchers.Main + mainJob)

    abstract suspend fun run(params: Params): Either<Failure, Type>

    operator fun invoke(
        params: Params,
        onResult: (Either<Failure, Type>) -> Unit = {}
    ) =
        uiScope.launch {
            onResult(withContext(Dispatchers.IO) {
                run(params)
            })
        }

    fun cancel() {
        mainJob.cancel()
    }

    class None
}
```

The GetMissions use case gets launched in the ViewModel. It's a pretty typical use of LiveData in a ViewModel. It stores LiveData that we can observe for changes and handles the request to fetch the data. It's really more of a presenter than the traditional view model. Except it handles rotation changes effortlessly.

```Kotlin
class MissionsViewModel(private val getMissions: GetMissions) : BaseViewModel() {
    val _missions = MutableLiveData<List<MissionsView>>()
    val missions: LiveData<List<MissionsView>>
        get() = _missions

    fun loadMissions() = getMissions(params = None()) { onResult ->
        onResult.either(::handleFailure, ::handleMissionList)
    }

    private fun handleMissionList(missions: List<Mission>) {
        this._missions.value = missions.map { MissionsView(it) }
    }

	// (handleFailure and it's associated LiveData is in a base ViewModel)

    // ... Factory stuff goes here
}
```

Finally, here's how we use it in a fragment:

```Kotlin
override fun onActivityCreated(savedInstanceState: Bundle?) {
	super.onActivityCreated(savedInstanceState)

	missionsViewModel = viewModel(viewModelFactory) {
        observe(missions, ::handleMissionList)
        failure(failure, ::handleFailure)
	}

	// ... tell the ViewModel to load the data
}
```

The viewModel function is an extension on Fragment from Fernando's example project.

Overall, it was just a thought experiment put into code. And it works as expected. And given the foundation, it's pretty easy to work with. But I'll tell you, I spent hours trying to understand the example code. It's very compartmentalized and a bit tricky to follow. I had pretty much given up on it. Then I took a really good online Kotlin course taught by Svetlana Isakova from Jetbrains. Later on, I went back and looked at the example again and found it considerably easier to understand. I'm actually thinking about consolidating a lot of it into sort of a core module for future experiments.

Inspiration:

* <a class="text-info" href="https://fernandocejas.com" target="_blank">Fernando Cejas</a>
* <a class="text-info" href="https://github.com/android10/Android-CleanArchitecture-Kotlin" target="_blank">Fernando's Kotlin Clean Architecture project</a>
