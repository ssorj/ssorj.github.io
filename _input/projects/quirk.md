# Quirk

Quirk is a tool for installing and testing Qpid source modules.  It is
intended to help you develop software that uses Qpid modules, and it
is used to generate and test Qpid releases.

[Source code](https://github.com/ssorj/quirk), [Packages](@site-url@/projects/magnum.html)

## Command line

To see what quirk thinks it's going to do, run the `status` command.

    $ quirk status
    quirk: Starting proton.status
    Module 'proton':
      source_location:   http://git-wip-us.apache.org/repos/asf/qpid-proton.git
      source_branch:     master
      source_dir:        /home/jross/.quirk/output/source/proton
      build_dir:         /home/jross/.quirk/output/build/proton
      release_tag:       master-20150123
    Finished proton.status
    Starting dispatch.status
    Module 'dispatch':
    [snip]

This will tell you what the module names are and what parameters each
will use to do its work.

For any command, you can limit the scope of the operation by supplying
the `--module` or `-m` option.  The `--module` option can be repeated.
If no modules are specified, all Qpid modules (all the ones reported
by `quirk status`) are used.

    $ quirk build --module cpp
    $ quirk build -m cpp -m jms

Use `export` to check out module source code, `build` to compile it,
and `install` to deploy it under the install prefix.  The `install`
command implies `build`, which in turn implies `export`.

    $ quirk export        # export
    $ quirk build         # export and build
    $ quirk install       # export, build, and install

The `release` command creates release artifacts.  Use the
`--release-tag` option to control the names of the resulting archives
and their internal root directory.  The default tag is the branch name
and a date stamp.

    $ quirk release --module cpp
    [-> ~/.quirk/output/release/qpid-cpp-trunk-20150306.tar.gz]
    $ quirk release --module cpp --release-tag 0.32-beta
    [-> ~/.quirk/output/release/qpid-cpp-0.32-beta.tar.gz]

The `test` command completes all of the foregoing and runs tests
against it.

    $ quirk test-build    # Implies build
    $ quirk test-install  # Implies install
    $ quirk test-release  # Implies release
    $ quirk test          # test-build, test-install, and test-release

The `env` command produces a shell-compatible environment for
accessing the installed resources.  You can source this output
directly into your shell to update the search paths for your session.

    $ quirk env
    export LD_LIBRARY_PATH=/home/jross/.quirk/output/install/lib64
    export PATH=/home/jross/.quirk/output/install/bin:/home/jross/.qu [snip]
    export PYTHONPATH=/home/jross/.quirk/output/install/lib64/proton/ [snip]
    $ source <(quirk env)

For developers, the main attraction is getting the stuff you want to
develop against installed and accessible to the shell where you are
working.

    $ quirk install
    [Wait a while]
    $ source <(quirk env)
    $ which qpidd
    ~/.quirk/output/install/sbin/qpidd
    $ which qdrouterd
    ~/.quirk/output/install/sbin/qdrouterd

If your environment is already setup to use an alternate install
prefix, you can tell quirk to install there.

    $ quirk install --prefix ~/.local

Quirk may also be used for simple continuous integration setup:

    $ quirk test
    $ quirk test --module dispatch

To prepare Qpid releases:

    [Establish your desired configuration in ~/.quirk/quirk.conf]
    $ quirk clean
    $ quirk test |& tee qpid-0.32-test.log
    $ quirk release --release-tag 0.32 |& tee qpid-0.32-release.log
    [See release artifacts at ~/.quirk/output/release]

## Output

By default, quirk's output appears under `$HOME/.quirk/output`.
Here's what you'll see under there:

    source             Source code exports
    build              Build trees
    install            The default installation prefix
    release            Release artifacts

The output directory can be overridden using the `--output` option.

## Configuration

Configuration parameters can be overriden by placing a config file at
`$HOME/.quirk/quirk.conf`.  The file content must be valid JSON.

By default, module code is fetched via the web from canonical upstream
sources.  If you'd prefer to use an existing local checkout, you can
indicate that with the `source_location` option.

    {
        "projects": {
            "qpid": {
                "modules": {
                    "proton": {
                        "source_location": "/home/jross/code/proton"
                    }
                }
            }
        }
    }

Without any configuration, quirk pulls everything from a module's
trunk or master branch.  Sometimes you don't want trunk--you want an
alternate branch.  You can specify that with the `source_branch`
option.

    {
        "projects": {
            "qpid": {
                "modules": {
                    "dispatch": {
                        "source_branch": "0.2"
                    }
                }
            }
        }
    }

There are example configurations at
<https://github.com/ssorj/quirk/tree/master/misc>.
