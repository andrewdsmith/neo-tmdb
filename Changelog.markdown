# Changelog

## In git master branch

New features:

* Adds methods to `Configuration` for fetching and caching the [TMDb
  configuration][], which can be used to build image URLs from a
  `Person#profile_path`.
* Adds an initial implementation of the `Person.find` method for getting a
  person by their TMDb id.

## 0.1.0 (2012-06-05)

New features:

* Adds an initial implementation of the `Person.where` method that searches for
  people on TMDb by name.

