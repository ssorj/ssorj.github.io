# Plano

Python functions for writing shell-style system scripts.

[Source code](https://github.com/ssorj/plano)

## Overview

Plano uses the global function namespace to provide shell-like direct
access to common script operations.

 - The character encoding is always UTF-8, and all strings are treated
   as unicode.
 - Temporary files and directories are cleaned up on exit unless there was an error.
 - As a matter of philosophy, Plano functions don't fuss, they just make it happen.  For instance,
   directories are generally created as needed.
 - Plano isn't shy about talking about what it's doing on the console.

## Installation

### Using Fedora packages

Use the `dnf` command to download and install the Fedora package.

    $ sudo dnf copr enable jross/ssorj
    $ sudo dnf install python-plano

### Installing from source

Use the `git` command to download the source.  Use `make` to run the
install procedure.

    $ git clone https://github.com/ssorj/plano.git
    $ cd plano/
    $ make
    $ make install

The default install location is `$HOME/.local`. Use the `PREFIX`
argument to change it.
    
    $ make PREFIX=/usr/local
    $ sudo make install

## Conventions for parameter names

 - `path` is a string path to a file or directory.
 - `dir` is a path to a directory.
 - `file` is a path to a file.
 - `name` is the file or directory name without any preceding path.
 - `extension` is the last dotted segment of a name, as in `.jar`.
 - `stem` is the name without its extension.
 - `pattern` is a shell glob, a la `*.py`.
 - `expr` is a regular expression.
 - `command` is something we pass to the shell.
 - `proc` is a process object.
 - `string` is a unicode string.

## Environment

    ENV                             Dictionary of environment variables
    ARGS                            List of command-line arguments; the 0th is the executable
    PATH_SEP                        '/' on posix, '\' on windows
    LINE_SEP                        '/n' on posix, '/n/r' on windows

## Path operations

    join(path, *paths)              -> path
    split(path)                     -> leading path, trailing name
    spit_extension(path)            -> path, extension

    parent_dir(path)                -> dir
    file_name(path)                 -> name
    name_extension(name)            -> extension
    name_stem(name)                 -> stem

    exists(path)                    -> True or False
    is_absolute(path)               -> True or False
    is_dir(path)                    -> True or False
    is_file(path)                   -> True or False
    is_link(path)                   -> True or False

    absolute_path(path)             -> path
    normalize_path(path)            -> path

## File operations

    copy(from_path, to_path)        -> to_path
    move(from_path, to_path)        -> to_path
    rename(path, expr, replacement) -> renamed path
    remove(path)                    -> path

    read(file)                      -> string
    write(file, string)             -> file
    append(file, string)            -> file
    prepend(file, string)           -> file
    touch(file)                     -> file
    tail(file, nlines)              -> string

These variants take a list of unicode strings, one per line.

    read_lines(file)                -> list of strings
    write_lines(file, lines)        -> file
    append_lines(file, lines)       -> file
    prepend_lines(file, lines)      -> file
    tail_lines(file, nlines)        -> list of strings

Operations on symlinks.

    make_link(source_path, link_file) -> link_file
    read_link(file)                   -> target_path

## Directory operations

    change_dir(dir)                 -> previous dir
    current_dir()                   -> dir
    home_dir(user="")               -> dir
    list_dir(dir, *patterns)        -> sorted list of names
    make_dir(dir)                   -> dir

Temporarily change the current working dir.  This is intended for use
with the Python `with` construct.

    with working_dir(dir):
        assert current_dir() == dir

Search a filesystem tree recursively.

    find(dir, *patterns)            -> sorted list of paths

Find any one match.  Return `None` if nothing matches.

    find_any_one(dir, *patterns)    -> path or None

Find one match, and *fail* if multiple are found.  Return `None` if
nothing matches.

    find_only_one(dir, *patterns)   -> path or None

## Temporary files and directories

    make_temp_file()                -> file
    make_temp_dir()                 -> dir

Make a temporary directory that is retained on exit.

    make_user_temp_dir()            -> dir

## Processes

Execute a shell command.  The command is a format string filled using
`args`.

    start_process(command, *args, **options) -> proc
    wait_for_process(proc)
    stop_process(proc)

    call_for_exit_code(command, *args, **options) -> exit code

These raise `CalledProcessError` on failure.

    call(command, *args, **options)
    call_for_output(command, *args, **options) -> string

End the current process.  With no arguments, exits with process exit
code 0.  Exits with 1 if `arg` is a string error message.  Exits with
the given code if `arg` is an integer.

    exit(arg=None, *args)

## Logging

    fail(message, *args)
    error(message, *args)
    warn(message, *args)
    notice(message, *args)
    debug(message, *args)

Configure log output.  Message level is `"debug"`, `"notice"`,
`"warn"`, or `"error"`.  The default output is standard error, and the
default threshold is `"notice"`.

    set_message_output(writeable)
    set_message_threshold(level)

## Miscellaneous

    sleep(seconds)

    make_archive(input_dir, output_dir, archive_stem) -> output file
    extract_archive(archive_file, output_dir)         -> output_dir
    rename_archive(archive_file, new_archive_stem)    -> output file

    random_port(min=49152, max=65535) -> port

    string_replace(string, expr, replacement, count=0) -> string

Get the executable name of the current process or `command`.

    program_name(command=None)

Flush standard output and error.

    flush()
