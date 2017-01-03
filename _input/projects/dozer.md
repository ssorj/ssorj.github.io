# Dozer

Dozer is a tool for installing and testing ActiveMQ and Qpid source
modules.

[Source code](https://github.com/ssorj/dozer)

## Installation

### Using Fedora packages

Use the `dnf` command to download and install the Fedora package.

    $ sudo dnf copr enable jross/ssorj
    $ sudo dnf install dozer

### Installing from source

Use the `git` command to download the source.  Use `make` to run the
install procedure.

    $ git clone https://github.com/ssorj/dozer.git
    $ cd dozer/
    $ make install

The default install location is `$HOME/.local`. Use the `PREFIX`
argument to change it.

    $ sudo make install PREFIX=/usr/local

## Using Dozer

To see what Dozer thinks it's going to do, run the `info` command.

    $ dozer info
    dozer: Starting qpid-proton.info
    dozer: Calling 'git ls-remote http://git-wip-us.apache.org/repos [...]
    Module 'qpid-proton':
      source_url:        http://git-wip-us.apache.org/repos/asf/qpid [...]
      source_branch:     master
      source_revision:   5afa455a5982eab0e5a4e6e6cf01fe12605870d9
      source_dir:        /home/jross/.cache/dozer/source/qpid-proton
      build_dir:         /home/jross/.cache/dozer/build/qpid-proton
      release_tag:       master-20160813-5afa455a
    dozer: Finished qpid-proton.info
    [...]

This will tell you what the module names are and what parameters each
will use to do its work.

For any command, you can limit the scope of the operation by supplying
the `--module` or `-m` option.  The `--module` option can be repeated.
If no modules are specified, all Qpid modules (all the ones reported
by `dozer info`) are used.

    $ dozer build --module qpid-cpp
    $ dozer build -m qpid-cpp -m qpid-jms

Use `export` to check out module source code, `build` to compile it,
and `install` to deploy it under the install prefix.  The `install`
command implies `build`, which in turn implies `export`.

    $ dozer export        # export
    $ dozer build         # export and build
    $ dozer install       # export, build, and install

The `release` command creates release artifacts.  Use the
`--release-tag` option to control the names of the resulting archives
and their internal root directory.  The default tag is the branch
name, a date stamp, and a revision.

    $ dozer release --module qpid-java
    [-> ~/.cache/dozer/release/qpid-java-20160814-1756121.tar.gz]
    $ dozer release --module qpid-java --release-tag 6.0.5-beta
    [-> ~/.cache/dozer/release/qpid-java-6.0.5-beta.tar.gz]

The `test` command completes all of the foregoing and runs tests
against it.

    $ dozer test          # Implies install and release

The `env` command produces a shell-compatible environment for
accessing the installed resources.  You can source this output
directly into your shell to update the search paths for your session.

    $ dozer env
    export LD_LIBRARY_PATH=/home/jross/.cache/dozer/install/lib64
    export PATH=/home/jross/.cache/dozer/install/bin:/home/jross/.ca [...]
    export PYTHONPATH=/home/jross/.cache/dozer/install/lib64/proton/ [...]
    $ source <(dozer env)

For developers, the main attraction is getting the stuff you want to
develop against installed and accessible to the shell where you are
working.

    $ dozer install
    [Wait a while]
    $ source <(dozer env)
    $ which qpidd
    ~/.cache/dozer/install/sbin/qpidd
    $ which qdrouterd
    ~/.cache/dozer/install/sbin/qdrouterd

If your environment is already setup to use an alternate install
prefix, you can tell dozer to install there.

    $ dozer install --prefix ~/.local

Dozer may also be used for simple continuous integration setup:

    $ dozer test
    $ dozer test --module qpid-dispatch

To prepare Qpid releases:

    $ dozer clean
    $ dozer test --module qpid-cpp --release-tag 1.35.1 |& tee qpid-cpp-1.35.1-test-output.txt
    [See release artifacts at ~/.cache/dozer/release]

## Output

By default, Dozer's output appears under `$HOME/.cache/dozer`.
Here's what you'll see under there:

    source             Source repository exports
    build              Build trees
    install            The default installation prefix
    release            Release artifacts

The output directory can be overridden using the `--output` option.
