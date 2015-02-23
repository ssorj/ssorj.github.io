# Plano

The notion here is to use the global function namespace for common
script operations.

 - At this point, this works for posix, not windows
 - The character encoding is always UTF-8
 - All temporary values are cleaned up on exit
 - Philosophy: Don't fuss, just do it; for instance, directories are generally
   created as needed
 - Philosophy: Don't be shy about talking about what you're doing on
   the console

## Parameters

 - A `path` parameter is a path to a file or directory
 - A `dir` parameter is a path to a directory
 - A `file` parameter is a path to a file
 - A `name` parameter is the file or directory name without any
   preceding path
 - A `pattern` parameter is a shell glob, a la `*.py`
 - An `expr` parameter is a regular expression
 - A `command` parameter is something we pass to the shell

## Environment

    ENV                       Dictionary of environment variables
    ARGV                      List of command-line arguments; 0th is executable
    PATH_SEP                  '/' on posix, '\' on windows
    LINE_SEP                  /n on posix, /n/r on windows

## Path operations

    join(head, tail)          -> path
    split(path)               -> head, tail
    spit_extension(path)      -> path, extension

    parent_dir(path)          -> dir
    file_name(path)           -> name
    name_stem(name)           -> stem
    name_extension(name)      -> file

    exists(path)              -> True or False
    is_absolute(path)         -> True or False
    is_dir(path)              -> True or False
    is_file(path)             -> True or False
    is_link(path)             -> True or False

    absolute_path(path)       -> path
    normalize_path(path)      -> path

## File operations

    copy(from_path, to_path)
    move(from_path, to_path)
    rename(path, expr, replacement)
    remove(path)

    read(file)                -> unicode
    write(file, string)
    append(file, string)
    prepend(file, string)
    touch(file)

These variants take a list of unicode strings, one per line.

    read_lines(file)          -> list<unicode>
    write_lines(file, lines)
    append_lines(file, lines)
    prepend(file, lines)

These are for stashing named values in a temporary location in the
filesystem, to make it easy to use those values when you invoke an
external command.  They return the path of the temporary file.

    make_temp(key)            -> path
    open_temp(key, mode="r")  -> file
    read_temp(key)            -> unicode
    write_temp(key, string)   -> path
    append_temp(key, string)  -> path
    prepend_temp(key, string) -> path

Operations on symlinks.

    make_link(source_path, link_file)
    read_link(file)

## Directory operations

    make_dir, list_dir, current_dir, change_dir

    make_temp_dir, make_user_temp_dir

    working_dir

    first_name, find, find_only_one

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
