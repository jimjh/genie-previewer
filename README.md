# Aladdin
[![Build Status](https://secure.travis-ci.org/jimjh/aladdin.png?branch=master)](https://travis-ci.org/jimjh/aladdin)
[![Dependency Status](https://gemnasium.com/jimjh/aladdin.png)](https://gemnasium.com/jimjh/aladdin)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jimjh/aladdin)

Generates lessons using the markdown document and tests provided by the author.

## Installation
Add this line to your application's Gemfile:

    gem 'aladdin'

And then execute:

    $> easy_install Pygments
    $> bundle install

Or install it yourself as:

    $> easy_install Pygments
    $> gem install aladdin

## Usage
Create a new directory for your notes _e.g._ `lesson_0`. Change into that
directory, then execute:

```sh
$> aladdin new
```

Update `index.md` and provide your unit tests in the lesson directory. Finally, execute aladdin to launch the Sinatra server:

```sh
$> aladdin server
```

A short guide can be obtained using

```sh
$> aladdin --help
```

Note that the following filenames are reserved:

- `__js`
- `__css`
- `__font`
- `__img`
- verify

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Troublesome Parts

1. Launch an Ubuntu instance
1. Install ruby through rvm
1. Install build-essentials
1. Install libxslt-dev libxml2-dev
