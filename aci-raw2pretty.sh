#!/usr/bin/env sh
# Recursively beautify all *.json into *_pretty.json using aci-filename-map.awk. All *_pretty.json are ignored.
# Parameters: <from_dir> [<to_dir>]

if [ -d $1 ]; then
	find $1 -name \*.json -not -name \*_pretty.json -type f | aci-filename-map.awk | sh -c '
		#echo Begin processing ...
		while [ $? -eq 0 ]  && read from to; do
			#echo processing $from ... 1>&2
			#echo -n .
			jq -a --tab '.' < $from > ${0:-.}/${to}_pretty.json 2>/dev/null || # fallback to my butifier
                        json-pretty.py < $from | unexpand -t 4 > ${0:-.}/${to}_pretty.json 
                        # you may allways use ``| expand -t 4`` to set desirable indentation depth
		done
		#echo Done
	' "$2"
else
	echo Bad source path! 1>&2
	exit 1
fi
