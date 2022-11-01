# Spoonacular

Hello! This project was developed to serve as a model for all my projects, based on everything that I've learned until now.

Chosen technologies:
* URLSession for api calls
* CoreData for database

## Architecture

The chosen architecture is VIP (a.k.a Clean Swift), an implementation of the Clean Architecture.

In this archicteture, a screen has the following elements:

* Scene: this is our view, responsible for rendering our screen.

* Interactor: the interactor is responsible for all the business logic and managing its state (I'm not delegating all state management to SwiftUI).

* Presenter: the presenter is responsible for transforming objects to view models (formatting date, currency, complex models to simplified data, etc).

* Router: the router, although we are currently not using it, has the routing logic and the passing data between screens.

* Model: here, we define how data is passed between each of the elements previously mentioned.

We also have other components that provides better supporting to our application, such as:

* ApiServices: responsible for making requests to the API.
* DatabaseServices: responsible for managing the database.
* Workers: responsible for doing heavy lifting like making api calls or database requests.

All components are developed based on some principles:
* SOLID
* KISS
* Dependency Injection
* We keep as much as possible the work running in background so we can keep the main thread free as much as possible

Some common procedures that happens during development:

* Creating the set of elements for every screen (scene, interactor, presenter, router, model)
* Creating api and database specific requests
* Making tests for every component

## Observations

Here I will explain some general thoughts about programming.

* Usually, an architecture such as VIP is complex and there are a lot of boilerplate, so I prefer using it only for projects that may have a long lifetime or could have several developers working together.
* For proofs of concepts or features that must be delivered as fast as possible, I prefer using simpler architectures such as MVC Cocoa (for storyboard based apps) or MVVM (for SwiftUI).
