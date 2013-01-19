## [Gistflow](http://gistflow.com) - social learning. [![Build Status](https://secure.travis-ci.org/gistflow/gistflow.png)](http://travis-ci.org/gistflow/gistflow)

Micro-blog platform for developers inspired by [Github:Gist](http://gist.github.com) and [Twitter](http://twitter.com).

## Contributing

You are always welcome to contribute or create issue. Checkout [issues page](https://github.com/gistflow/gistflow/issues).

## Setup

* git clone
* bundle
* cp config/database.yml.example config/database.yml
* configure your database.yml file
* be sure you have [postgres](http://russbrooks.com/2010/11/25/install-postgresql-9-on-os-x) and [redis](https://github.com/defunkt/resque#installing-redis) installed and launched
* rake db:setup
* download and run [ElasticSearch](http://www.elasticsearch.org) (simply `brew install elasticsearch` if you're on MacOSx and follow instructions)

### Github Authorization on your local machine

You should run app at `http://gistflow.dev/` on the `:80` port to speak with GitHub omniauth freely. [Pow](http://pow.cx/) and [Powder](https://github.com/rodreegez/powder) will help you much with it.

```
curl get.pow.cx | sh
gem install powder
powder link
```

## Testing

Every new feature comes with bunch of rspec and capybara tests. Be sure to write all necessary tests and launch `rspec .` to check all of them passed.

## Contributors

* [Jan Bernacki](https://github.com/releu) (releu)
* [Anatoli Makarevich](https://github.com/makaroni4) (makaroni4)
* [Nick Shebanov](https://github.com/killthekitten) (killthekitten)

## License

The source code for Gistflow is available under the [Creative Commons Attribution-NonCommercial 3.0 Unported License](http://creativecommons.org/licenses/by-nc/3.0)
