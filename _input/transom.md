# Transom

Transom renders website content from markdown source files.

## Development

To setup paths in your development environment, source the `devel.sh`
script from the project directory.

    $ cd transom/
    transom$ source devel.sh

The 'devel' make target uses the environment established by 'devel.sh'
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

Use the `--verbose` option to see lots of logging.

## Adding content

Use your editor to create or edit a file under your input directory.

    $ emacs input/some-page.md

Render the site.

    $ transom input/ /home/jross/output/

Look at the result in your browser by navigating to the output
location:

    file:///home/jross/output/some-page.html

## Special files

Transom looks for two special files under the input directory.

    input/_config.ini     # Custom site variables
    input/_template.html  # The template for HTML pages

These files are not copied to the output.

## Render transformations

Transom takes files in the input directory reproduces them in the
output directory.  The following transformations are applied in the
process:

 - `.html.in` files are wrapped in the site template and copied
 - `.md` (markdown) files are converted to HTML and then treated
   just as `.html.in` files are
 - All other files are copied
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

`$INPUT_DIR/_config.ini` defines some variables usable for any input
page.  To illustrate:

    @current-release@          -> 0.20

By default, the `site-url` placeholder is set to a filesystem path in
your development environment, to allow for local testing.  When
publishing work to a public website root, you'll need to supply the
appropriate site url.

    $ transom --site-url "http://example.com/" input/ output/ 

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

;; Discuss @path-navigation@ and @content@
