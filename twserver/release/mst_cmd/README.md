ezhttp
========

这是在linux上一键配置http环境的shell脚本
项目地址：http://www.centos.bz/ezhttp/



export: Create an unversioned copy of a tree.
usage: 1. export [-r REV] URL[@PEGREV] [PATH]
       2. export [-r REV] PATH1[@PEGREV] [PATH2]

  1. Exports a clean directory tree from the repository specified by
     URL, at revision REV if it is given, otherwise at HEAD, into
     PATH. If PATH is omitted, the last component of the URL is used
     for the local directory name.

  2. Exports a clean directory tree from the working copy specified by
     PATH1, at revision REV if it is given, otherwise at WORKING, into
     PATH2.  If PATH2 is omitted, the last component of the PATH1 is used
     for the local directory name. If REV is not specified, all local
     changes will be preserved.  Files not under version control will
     not be copied.

  If specified, PEGREV determines in which revision the target is first
  looked up.

Valid options:
  -r [--revision] ARG      : ARG (some commands also take ARG1:ARG2 range)
                             A revision argument can be one of:
                                NUMBER       revision number
                                '{' DATE '}' revision at start of the date
                                'HEAD'       latest in repository
                                'BASE'       base rev of item's working copy
                                'COMMITTED'  last commit at or before BASE
                                'PREV'       revision just before COMMITTED
  -q [--quiet]             : print nothing, or only summary information
  -N [--non-recursive]     : obsolete; try --depth=files or --depth=immediates
  --depth ARG              : limit operation by depth ARG ('empty', 'files',
                            'immediates', or 'infinity')
  --force                  : force operation to run
  --native-eol ARG         : use a different EOL marker than the standard
                             system marker for files with the svn:eol-style
                             property set to 'native'.
                             ARG may be one of 'LF', 'CR', 'CRLF'
  --ignore-externals       : ignore externals definitions

Global options:
  --username ARG           : specify a username ARG
  --password ARG           : specify a password ARG
  --no-auth-cache          : do not cache authentication tokens
  --non-interactive        : do no interactive prompting
  --trust-server-cert      : accept unknown SSL server certificates without
                             prompting (but only with '--non-interactive')
  --config-dir ARG         : read user configuration files from directory ARG
  --config-option ARG      : set user configuration option in the format:
                                 FILE:SECTION:OPTION=[VALUE]
                             For example:
                                 servers:global:http-library=serf


svn export svn://192.168.0.246/release/server/1.6.0/ebin /data/mst_server/a_fun_1/ebin --username release --password mst_at_2funfun --no-auth-cache
