# Transom

Transom renders website content from markdown source files.

## Source code

The Transom source code lives at GitHub.

> <https://github.com/ssorj/transom>

## Development

To setup paths in your development environment, source the `devel.sh`
script from the project directory.

    $ cd transom/
    transom$ source devel.sh

The `devel` make target uses the environment established by `devel.sh`
to install and test your checkout.

    transom$ make devel

## Installation

    $ cd transom/
    transom$ make build
    transom$ sudo make install

The default install location is `/usr/local`.  Use the `PREFIX`
argument to change it.

    transom$ sudo make install PREFIX=/some/path

## Project layout

    devel.sh              # Sets up your project environment
    Makefile              # Defines the make targets
    bin/                  # Command-line tools
    python/               # Python library code; used by scripts
    scripts/              # Scripts called by Makefile rules
    build/                # The default build location
    install/              # The devel install location

## Make targets

After that most everything is accomplished by running make targets.
These are the important ones:

    transom$ make build   # Builds the code
    transom$ make install # Installs the code
    transom$ make devel   # Cleans, builds, installs, tests
    transom$ make clean   # Removes build/ and install/

## Command line

The `transom` command-line tool takes an input directory and an output
directory.

    $ transom your-input-dir/ your-output-dir/
    
Use the `--site-url` option to control the prefix used for HTML links.

    $ transom --site-url "http://ssorj.net" input/ output/

By default, the `site-url` placeholder is set to a filesystem path in
your development environment, to allow for local testing.  When
publishing work to a public website root, you'll need to supply the
appropriate site url.

Use the `--verbose` option to see lots of logging.

## Adding content

Use your editor to create or edit a file under your input directory.

    $ emacs input/some-page.md

Render the site.

    $ transom input/ /home/jross/output/

Look at the result in your browser by navigating to the output
location.

    file:///home/jross/output/some-page.html

## Special files

Transom looks for two special files under the input directory.

    $INPUT_DIR/_config.ini     # Custom placeholders
    $INPUT_DIR/_template.html  # The template for HTML pages

These files are not copied to the output.

## Render transformations

Transom takes files in the input directory and reproduces them in the
output directory.  The following transformations are applied in the
process.

 - `.html.in` files are wrapped in the site template and copied
 - `.md` (Markdown) files are converted to HTML, wrapped in the site
   template, and copied
 - All other files are simply copied
 - All Markdown, HTML, Javascript, and CSS files undergo substitution
   for `@placeholders@`

## Markdown syntax

Markdown is a markup language inspired by plain text conventions.
This page is written in markdown.  See this [syntax guide][syntax].

The particular markdown implementation the site code uses is
[python-markdown2][markdown2].

I personally benefit from using [emacs markdown mode][emacs].  On
Fedora it is part of the `emacs-goodies` package.

[syntax]: http://daringfireball.net/projects/markdown/syntax
[markdown2]: https://github.com/trentm/python-markdown2
[emacs]:  http://jblevins.org/projects/markdown-mode/

## Placeholders

`$INPUT_DIR/_config.ini` can be used to define variables for use in
any input page.  The values will be substituted on output.

    [main]
    current-release = 1.0
    current-release-url = http://example.com/releases/1.0/index.html

The placeholder can then be embedded in any input file.  Placeholders
are marked with a beginning and ending `@`.

    [@current-release@](@current-release-url@) is the current release
    
    <a href="http://example.com/releases/1.0/index.html">1.0</a> is
    the current release

There are some built-in placeholders for important cases.

    site-url              The URL prefix for your site
    path-navigation       An HTML list for use in site navigation
    title                 Positions the template title
    content               Positions the template content

;; ## Checking links
;; 
;; The site tools offer a way to check that all your hyperlinks are
;; working.
;; 
;;     # Usage: make check-links [INTERNAL=1] [EXTERNAL=0]
;; 
;;     # Check internal links only
;;     transom$ make check-links
;;
;;     # Check external links as well
;;     transom$ make check-links EXTERNAL=1
