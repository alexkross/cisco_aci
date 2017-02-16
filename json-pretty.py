#!/usr/bin/env python
# Self documented - trivial, see the source code.
# Possible alternatives: jq (c, fastest).
# ; jshon

from sys import stdin, stdout

try: # Or use anyjson.
    from simplejson import load, dump
except ImportError:
    try:
        from json import load, dump
    except ImportError:
        #print("Install simplejson compatible python module.", file=stderr)
        raise "Install simplejson compatible python module."

# ASCII convertion is important for some Cisco ACI configuration dumps.
dump(load(stdin), stdout, ensure_ascii=True, sort_keys=True, indent=4, separators=(',', ': '))
