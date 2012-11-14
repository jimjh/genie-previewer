# Aladdin
[![Build Status](https://secure.travis-ci.org/jimjh/aladdin.png?branch=master)](https://travis-ci.org/jimjh/aladdin)
[![Dependency Status](https://gemnasium.com/jimjh/aladdin.png)](https://gemnasium.com/jimjh/aladdin)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jimjh/aladdin)

Generates tutorials using the set of markdown documents provided by the author.

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
Create a new directory for your notes _e.g._ `my_tutorial`. Change into that
directory, and create your notes using GitHub-Flavored Markdown. It might look
like:

    my_tutorial/
      01-introduction.md
      02-the-beginning.md
      03-the-end.md

Finally, execute aladdin to launch the Sinatra server:

    $> aladdin

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
