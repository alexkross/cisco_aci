#!/usr/bin/env sh
jq -c 'path(..|select(.attributes!=null)?)' | sed 's/,"children",[[:digit:]]*//g;s#,#/#g;s/^\[\(.*\)\]$/\/\1/' | tr -d '[]"' | sort | uniq
