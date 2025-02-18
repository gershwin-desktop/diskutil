# diskutil

Inspired by the MacOS command line utility of the same name. This cli app is made with GNUstep and heavily leverages ZFS and FreeBSD tools

### Implemented commands

> `diskutil list [--json | --xml]` 

WIll output the names of all disk devices attached to FreeBSD. Supports plain text, JSON, and XML output formats

> `diskutil listDiskProviders [--json | --xml]` 

WIll output the equivalent of FreeBSD's `geom disk list`. Supports plain text, JSON and XML output formats

> `diskutil info <diskname> [--json | --xml]` 

WIll output the equivalent of FreeBSD's `geom disk list` but only for the specified disk. Supports plain text, JSON and XML output formats


### TODO

- mount
- unmount
