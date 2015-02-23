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

## Parameters

 - `path` is a string path to a file or directory
 - `dir` is a path to a directory
 - `file` is a path to a file
 - `name` is the file or directory name without any preceding path
 - `extension` is the terminal 'dot' segment of a name, as in `.jar`, `.patch`
 - `stem` is the name without its extension
 - `pattern` is a shell glob, a la `*.py`
 - `expr` is a regular expression
 - `command` is something we pass to the shell
 - `string` is a unicode string

## Environment

    ENV                            Dictionary of environment variables
    ARGV                           List of command-line arguments; 0th is the executable
    PATH_SEP                       '/' on posix, '\' on windows
    LINE_SEP                       /n on posix, /n/r on windows

## Path operations

    join(head, tail)               -> path
    split(path)                    -> head, tail
    spit_extension(path)           -> path, extension

    parent_dir(path)               -> dir
    file_name(path)                -> name
    name_extension(name)           -> extension
    name_stem(name)                -> stem

    exists(path)                   -> True or False
    is_absolute(path)              -> True or False
    is_dir(path)                   -> True or False
    is_file(path)                  -> True or False
    is_link(path)                  -> True or False

    absolute_path(path)            -> path
    normalize_path(path)           -> path

## File operations

    copy(from_path, to_path)
    move(from_path, to_path)
    rename(path, expr, replacement)
    remove(path)

    read(file)                     -> string
    write(file, string)
    append(file, string)
    prepend(file, string)
    touch(file)

These variants take a list of unicode strings, one per line.

    read_lines(file)               -> list of strings
    write_lines(file, lines)
    append_lines(file, lines)
    prepend(file, lines)

These are for stashing named values in a temporary location in the
filesystem, to make it easy to use those values when you invoke an
external command.  They return the path of the temporary file.

    make_temp(key)                 -> file
    open_temp(key, mode="r")       -> Python file object
    read_temp(key)                 -> string
    write_temp(key, string)        -> file
    append_temp(key, string)       -> file
    prepend_temp(key, string)      -> file

Operations on symlinks.

    make_link(source_path, link_file)
    read_link(file)

## Directory operations

    make_dir(dir)                  -> dir
    list_dir(dir, *patterns)       -> sorted list of names
    change_dir(dir)                -> previous dir
    current_dir()                  -> dir
    make_temp_dir()                -> dir

Make a temporary directory that is retained on exit.

    make_user_temp_dir()           -> dir

Temporarily change the current working dir.  This is intended for use
with the Python `with` construct.

    with working_dir(dir):
        assert current_dir() == dir

Get the 0th match from `list_dir(dir, *patterns)`.  Return `None` if
there's no match.

    first_name(dir, *patterns)     -> name or None

Search a filesystem tree recursively.

    find(dir, *patterns)           -> sorted list of paths

Find only one match, and fail if multiple are found.  Return `None` if
nothing matches.

    find_only_one(dir, *patterns)  -> path or None

## Standard paths

    get_home_dir

    get_bin_dir get_sbin_dir get_include_dir get_lib_dir

## String operations

    string_replace

## Process execution

    call, call_for_output

## Logging

    fail, error, warn, notice, debug

    exit

## Miscellaneous

    make_archive, extract_archive, rename_archive

    random_port
