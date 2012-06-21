# Changelog

## In git master branch

New features:

* Caching support through `Configuration#cache`.

## 0.2.0 (2012-06-15)

New features:

* The `Person#profile_image_url` method, which uses the base image URL fetched
  from the TMDb configuration.
* Methods on `Configuration` for fetching and caching the [TMDb
  configuration][], which can be used to build image URLs from a
  `Person#profile_path`.
* An initial implementation of the `Person.find` method for getting a person by
  their TMDb id.

[TMDb configuration]: http://help.themoviedb.org/kb/api/configuration

## 0.1.0 (2012-06-05)

New features:

* An initial implementation of the `Person.where` method that searches for
  people on TMDb by name.

