# Quirk

Quirk is a tool for installing and testing Qpid source modules.  It is
intended to help you develop software that uses Qpid modules, and it
is used to generate and test Qpid releases.

[Source code](https://github.com/ssorj/quirk)

## Installation

### Using Fedora packages

Use the `dnf` command to download and install the Fedora package.

    $ sudo dnf copr enable jross/ssorj
    $ sudo dnf install quirk

### Installing from source

Use the `git` command to download the source.  Use `make` to run the
install procedure.

    $ git clone https://github.com/ssorj/quirk.git
    $ cd quirk/
    $ make install

The default install location is `$HOME/.local`. Use the `PREFIX`
argument to change it.

    $ sudo make install PREFIX=/usr/local

## Using Quirk

To see what quirk thinks it's going to do, run the `info` command.

    $ quirk info
    quirk: Starting qpid-proton.info
    quirk: Calling 'git ls-remote http://git-wip-us.apache.org/repos [...]
    Module 'qpid-proton':
      source_url:        http://git-wip-us.apache.org/repos/asf/qpid [...]
      source_branch:     master
      source_revision:   5afa455a5982eab0e5a4e6e6cf01fe12605870d9
      source_dir:        /home/jross/.cache/quirk/source/qpid-proton
      build_dir:         /home/jross/.cache/quirk/build/qpid-proton
      release_tag:       master-20160813-5afa455a
    quirk: Finished qpid-proton.info
    [...]

This will tell you what the module names are and what parameters each
will use to do its work.

For any command, you can limit the scope of the operation by supplying
the `--module` or `-m` option.  The `--module` option can be repeated.
If no modules are specified, all Qpid modules (all the ones reported
by `quirk info`) are used.

    $ quirk build --module qpid-cpp
    $ quirk build -m qpid-cpp -m qpid-jms

Use `export` to check out module source code, `build` to compile it,
and `install` to deploy it under the install prefix.  The `install`
command implies `build`, which in turn implies `export`.

    $ quirk export        # export
    $ quirk build         # export and build
    $ quirk install       # export, build, and install

The `release` command creates release artifacts.  Use the
`--release-tag` option to control the names of the resulting archives
and their internal root directory.  The default tag is the branch
name, a date stamp, and a revision.

    $ quirk release --module qpid-java
    [-> ~/.cache/quirk/release/qpid-java-20160814-1756121.tar.gz]
    $ quirk release --module qpid-java --release-tag 6.0.5-beta
    [-> ~/.cache/quirk/release/qpid-java-6.0.5-beta.tar.gz]

The `test` command completes all of the foregoing and runs tests
against it.

    $ quirk test          # Implies install and release

The `env` command produces a shell-compatible environment for
accessing the installed resources.  You can source this output
directly into your shell to update the search paths for your session.

    $ quirk env
    export LD_LIBRARY_PATH=/home/jross/.cache/quirk/install/lib64
    export PATH=/home/jross/.cache/quirk/install/bin:/home/jross/.ca [...]
    export PYTHONPATH=/home/jross/.cache/quirk/install/lib64/proton/ [...]
    $ source <(quirk env)

For developers, the main attraction is getting the stuff you want to
develop against installed and accessible to the shell where you are
working.

    $ quirk install
    [Wait a while]
    $ source <(quirk env)
    $ which qpidd
    ~/.cache/quirk/install/sbin/qpidd
    $ which qdrouterd
    ~/.cache/quirk/install/sbin/qdrouterd

If your environment is already setup to use an alternate install
prefix, you can tell quirk to install there.

    $ quirk install --prefix ~/.local

Quirk may also be used for simple continuous integration setup:

    $ quirk test
    $ quirk test --module qpid-dispatch

To prepare Qpid releases:

    $ quirk clean
    $ quirk test --module qpid-cpp --release-tag 1.35.1 |& tee qpid-cpp-1.35.1-test-output.txt
    [See release artifacts at ~/.cache/quirk/release]

## Output

By default, quirk's output appears under `$HOME/.cache/quirk`.
Here's what you'll see under there:

    source             Source repository exports
    build              Build trees
    install            The default installation prefix
    release            Release artifacts

The output directory can be overridden using the `--output` option.
