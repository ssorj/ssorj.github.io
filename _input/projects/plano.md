# Plano

Python functions for writing shell-style system scripts.

## Source code

> <https://github.com/ssorj/plano>

## Overview

The notion here is to use the global function namespace for common
script operations.

 - At this point, this works for posix, not windows
 - The character encoding is always UTF-8, and all strings are treated
   as unicode
 - All temporary files are cleaned up on exit
 - As a matter of philosophy, don't fuss, just do it; for instance,
   directories are generally created as needed
 - And don't be shy about talking about what you're doing on the
   console

## Example

        from plano import *
        
        temp_dir = make_temp_dir()
        example_file = write(join(temp_dir, "example.a"), "Hello")
        example_file = move(example_file, join(temp_dir, "example.b"))
        print read(example_file)

## Parameters

 - `path` is a string path to a file or directory
 - `dir` is a path to a directory
 - `file` is a path to a file
 - `name` is the file or directory name without any preceding path
 - `extension` is the last dotted segment of a name, as in `.jar`, `.patch`
 - `stem` is the name without its extension
 - `pattern` is a shell glob, a la `*.py`
 - `expr` is a regular expression
 - `command` is something we pass to the shell
 - `string` is a unicode string

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

These variants take a list of unicode strings, one per line.

    read_lines(file)                -> list of strings
    write_lines(file, lines)        -> file
    append_lines(file, lines)       -> file
    prepend_lines(file, lines)      -> file

These are for stashing named values in a temporary location in the
filesystem, to make it easy to use those values when you invoke an
external command.  They return the path of the temporary file.

    make_temp(key)                  -> file
    open_temp(key, mode="r")        -> Python file object
    read_temp(key)                  -> string
    write_temp(key, string)         -> file
    append_temp(key, string)        -> file
    prepend_temp(key, string)       -> file

Operations on symlinks.

    make_link(source_path, link_file) -> link_file
    read_link(file)                   -> target_path

## Directory operations

    change_dir(dir)                 -> previous dir
    current_dir()                   -> dir
    home_dir(user="")               -> dir
    list_dir(dir, *patterns)        -> sorted list of names
    make_dir(dir)                   -> dir
    make_temp_dir()                 -> dir

Make a temporary directory that is retained on exit.

    make_user_temp_dir()            -> dir

Temporarily change the current working dir.  This is intended for use
with the Python `with` construct.

    with working_dir(dir):
        assert current_dir() == dir

Get the 0th match from `list_dir(dir, *patterns)`.  Return `None` if
there's no match.

    first_name(dir, *patterns)      -> name or None

Search a filesystem tree recursively.

    find(dir, *patterns)            -> sorted list of paths

Find only one match, and fail if multiple are found.  Return `None` if
nothing matches.

    find_only_one(dir, *patterns)   -> path or None

## Processes

    call(command, *args, **options)
    call_for_output(command, *args, **options) -> string

    exit(message=None, *args)

## Logging

    fail(message, *args)
    error(message, *args)
    notice(message, *args)
    debug(message, *args)

## Miscellaneous

    make_archive(input_dir, output_dir, archive_stem) -> output_file
    extract_archive(archive_file, output_dir)         -> output_dir
    rename_archive(archive_file, new_archive_stem)    -> output_file

    random_port(min=49152, max=65535) -> port

    string_replace(string, expr, replacement, count=0) -> string
