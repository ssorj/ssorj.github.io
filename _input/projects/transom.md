# Transom

Transom renders website content from markdown source files.

[Source code](https://github.com/ssorj/transom)

## Installation

<!-- ### Using Fedora packages -->

<!-- Use the `dnf` command to download and install the Fedora package. -->

<!--     $ sudo dnf copr enable jross/ssorj -->
<!--     $ sudo dnf install transom -->

### Installing from source

Use the `git` command to download the source.  Use `make` to run the
install procedure.

    $ git clone https://github.com/ssorj/transom.git
    $ cd transom/
    $ make install

The default install location is `$HOME/.local`. Use the `PREFIX`
argument to change it.

    $ make PREFIX=/usr/local
    $ sudo make install

## Command line

The `transom` command-line tool takes an input directory and an output
directory.

    $ transom render some-input-dir/ some-output-dir/

Use the `--site-url` option to control the prefix used for HTML links.

    $ transom render --site-url "http://ssorj.net" input/ output/

By default, the `site_url` placeholder is set to a filesystem path in
your development environment, to allow for local testing.  When
publishing work to a public website root, you'll need to supply the
appropriate site url.

Use the `--verbose` option to see lots of logging.

## Adding content

Use your editor to create or edit a file under your input directory.

    $ emacs input/some-page.md

Render the site.

    $ transom render input/ output/

Look at the result in your browser by navigating to the output
location.

    file:///home/jross/output/some-page.html

<!-- ## Special files -->

<!-- Transom looks for two special files under the input directory. -->

<!--     $INPUT_DIR/_transom_config.py      # Custom placeholders -->
<!--     $INPUT_DIR/_transom_template.html  # The template for HTML pages -->

<!-- These files are not copied to the output. -->

## Render transformations

Transom takes files in the input directory and reproduces them in the
output directory.  The following transformations are applied in the
process.

 - `.html.in` files are wrapped in the site template and copied
 - `.md` (Markdown) files are converted to HTML, wrapped in the site
   template, and copied
 - All other files are simply copied
 - All Markdown, HTML, Javascript, and CSS files undergo substitution
   for placeholders.

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

`$INPUT_DIR/_transom_config.py` can be used to define variables and
functions for use in any input page.  The values will be evaluated on
output.

    current_release = "1.0"
    current_release_url = "http://example.com/releases/1.0/index.html"

The placeholder can then be embedded in any input file.  Placeholders
are enclosed in double curly braces, as in
<code>&#123;&#123;current_release&#125;&#125;</code>.

There are some built-in placeholders for important cases.

<pre><code>&#123;&#123;site_url&#125;&#125;              The URL prefix for your site
</code></pre>

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
