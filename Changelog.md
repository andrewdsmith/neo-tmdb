# Changelog

## 0.4.0 (2012-07-15)

New features:

* Fault tolerance in `Person.find`. Returns a `NullObject` instance if
  the TMDb service is unavailable. This can be configured through
  `Configuration#null_person`. See the newly created feature files for
  examples.

Fixes:

* Raise `TMDb::ServiceUnavailable` error from calls based on
  `TMDb.get_api_response` when the service is unavailable or API limits have
  been exceeded.

## 0.3.1 (2012-06-27)

Fixes:

* Return nil from `Person#profile_image_url` when `Person#profile_path` is nil.

## 0.3.0 (2012-06-25)

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

