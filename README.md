## [Gistflow](http://gistflow.com) - social learning. [![Build Status](https://secure.travis-ci.org/gistflow/gistflow.png)](http://travis-ci.org/gist-flow/gistflow)

Micro-blog platform for developers inspired by [Gist.github.com](http://gist.github.com) and [Twitter](http://twitter.com).

## Contributing

You are always welcome to contribute or create issue. Checkout [issues page](https://github.com/gist-flow/gistflow/issues).

## Setup

* git clone
* bundle
* configure your database.yml file
* be shure you have [postgres](http://russbrooks.com/2010/11/25/install-postgresql-9-on-os-x) and [redis](https://github.com/defunkt/resque#installing-redis) installed and launched
* rake db:create && rake db:migrate && rake db:seed
* rails s

## Testing

Every new feature comes with bunch of rspec and capybara tests. Be sure to write all necessary tests and launch `rspec .` to check all of them passed.

## Contributors

* [Jan Bernacki](https://github.com/makaroni4) (releu)
* [Anatoli Makarevich](https://github.com/releu) (makaroni4)

## License

The source code for Gistflow is available under the [Creative Commons Attribution-NonCommercial 3.0 Unported License](http://creativecommons.org/licenses/by-nc/3.0)