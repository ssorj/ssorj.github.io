# Rivet

Rivet is a tool for installing and testing ActiveMQ and Qpid source
modules.

[Source code](https://github.com/ssorj/rivet)

## Installation

### Using Fedora packages

Use the `dnf` command to download and install the Fedora package.

    $ sudo dnf copr enable jross/ssorj
    $ sudo dnf install rivet

### Installing from source

Use the `git` command to download the source.  Use `make` to run the
install procedure.

    $ git clone https://github.com/ssorj/rivet.git
    $ cd rivet/
    $ make install

The default install location is `$HOME/.local`. Use the `PREFIX`
argument to change it.

    $ sudo make install PREFIX=/usr/local

## Using Rivet

To see what Rivet thinks it's going to do, run the `info` command.

    $ rivet info all
    rivet: Starting qpid-proton.info
    rivet: Calling 'git ls-remote http://git-wip-us.apache.org/repos [...]
    Module 'qpid-proton':
      source_url:        http://git-wip-us.apache.org/repos/asf/qpid [...]
      source_branch:     master
      source_revision:   5afa455a5982eab0e5a4e6e6cf01fe12605870d9
      source_dir:        /home/jross/.cache/rivet/source/qpid-proton
      build_dir:         /home/jross/.cache/rivet/build/qpid-proton
      release_tag:       master-20160813-5afa455a
    rivet: Finished qpid-proton.info
    [...]

This will tell you what the module names are and what parameters each
will use to do its work.

All commands (except `env`) take a list of module names or `all`.  The
latter tells Rivet to perform the operation for every modules reported
by `rivet info all`.

You can specify a module revision by appending `@<revision>` to the
module name, as in `qpid-cpp@25e73e5`.  Otherwise, Rivet uses the
current tip of the master or trunk branch.

    $ rivet build qpid-cpp
    $ rivet build qpid-cpp qpid-jms@1783666
    $ rivet build all

Use `export` to check out module source code, `build` to compile it,
and `install` to deploy it under the install prefix.  The `install`
command implies `build`, which in turn implies `export`.

    $ rivet export [...]  # export
    $ rivet build  [...]  # export and build
    $ rivet install [...] # export, build, and install

The `export` command will not re-export a source revision it already
has.  Use `clean` to start from scratch.

    $ rivet clean qpid-cpp qpid-jms
    $ rivet clean all

The `release` command creates release artifacts.  Use the
`--release-tag` option to control the names of the resulting archives
and their internal root directory.  The default tag is the branch
name, a date stamp, and a revision.

    $ rivet release qpid-java
    [-> ~/.cache/rivet/release/qpid-java-20160814-1756121.tar.gz]
    $ rivet release qpid-java --release-tag 6.0.5-beta
    [-> ~/.cache/rivet/release/qpid-java-6.0.5-beta.tar.gz]

The `test` command completes all of the foregoing and runs tests
against it.

    $ rivet test all      # Implies install and release

The `env` command produces a shell-compatible environment for
accessing the installed resources.  You can source this output
directly into your shell to update the search paths for your session.

    $ rivet env
    export LD_LIBRARY_PATH=/home/jross/.cache/rivet/install/lib64
    export PATH=/home/jross/.cache/rivet/install/bin:/home/jross/.ca [...]
    export PYTHONPATH=/home/jross/.cache/rivet/install/lib64/proton/ [...]
    $ source <(rivet env)

For developers, the main attraction is getting the stuff you want to
develop against installed and accessible to the shell where you are
working.

    $ rivet install all
    [Wait a while]
    $ source <(rivet env)
    $ which qpidd
    ~/.cache/rivet/install/sbin/qpidd
    $ which qdrouterd
    ~/.cache/rivet/install/sbin/qdrouterd

If your environment is already setup to use an alternate install
prefix, you can tell rivet to install there.

    $ rivet install --prefix ~/.local

Rivet may also be used for simple continuous integration setup:

    $ rivet test qpid-dispatch

To prepare a Qpid C++ release:

    $ rivet clean qpid-cpp
    $ rivet test qpid-cpp --release-tag 1.35.1 |& tee qpid-cpp-1.35.1-test-output.txt
    [See release artifacts at ~/.cache/rivet/release]

## Output

By default, Rivet's output appears under `$HOME/.cache/rivet`.
Here's what you'll see under there:

    source             Exported source trees
    build              Build trees
    install            The default installation prefix
    release            Release artifacts

The output directory can be overridden using the `--output` option.
