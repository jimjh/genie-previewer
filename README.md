# Aladdin a.k.a. genie-previewer
[![Build Status](https://secure.travis-ci.org/jimjh/genie-previewer.png?branch=master)](https://travis-ci.org/jimjh/genie-previewer)
[![Dependency Status](https://gemnasium.com/jimjh/genie-previewer.png)](https://gemnasium.com/jimjh/genie-previewer)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jimjh/genie-previewer)

Previews lessons using the markdown document and tests provided by the author.

## Installation

    $> easy_install Pygments
    $> gem install aladdin

## Usage
Create a new directory for your lesson _e.g._ `lesson_0`. Change into that
directory, then execute:

```sh
$> aladdin new
```

Update `index.md` and provide your unit tests in the lesson directory. Finally, execute aladdin to launch the Sinatra server:

```sh
$> aladdin server
```

Your lesson may be previewed at `http://localhost:3456`.

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
