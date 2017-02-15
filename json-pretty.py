#!/usr/bin/env python

from sys import stdin, stdout

try:
    from simplejson import load, dump
except ImportError:
    try:
        from json import load, dump
    except ImportError:
        print("Install simplejson compatible python module.", file=stderr)
        raise

# ASCII convertion is important for some Cisco ACI configuration dumps.
dump(load(stdin), stdout, ensure_ascii=True, sort_keys=True, indent=4, separators=(',', ': '))
