#!/usr/bin/env sh
# Recursively beautify all *.json into *_pretty.json using aci-filename-map.awk. All *_pretty.json are ignored.
# Parameters: <from_dir> [<to_dir>]

set -e

if [[ -f $1 ]]; then
	TS=$(basename -s .tar.gz $1)
	TS=${TS#${EXPORT_PREFIX}}
	mkdir -p ${TS}/config && tar -xzf $1 -C $TS
	find $TS -name \*.json -not -name \*_pretty.json -type f | aci-filename-map.awk | sh -c '
		#echo Begin processing ...
		while [ $? -eq 0 ]  && read from to; do
			#echo processing $from ... 1>&2
			#echo -n .
			jq -a --tab '.' < $from > ${0:-.}/${to}_pretty.json 2>/dev/null || # fallback to my butifier
                        json-pretty.py < $from | unexpand -t 4 > ${0:-.}/${to}_pretty.json 
                        # you may allways use ``| expand -t 4`` to set desirable indentation depth
		done
		#echo Done
	' "${TS}/config"
	RES=$?
else
	echo Bad source path! 1>&2
	exit 1
fi
set +e
TARGET=config.json
if [[ $RES -eq 0 ]]; then
	#rm -i $TARGET
  if (( ACI_NO_SEC )); then
    aci-no-sec.sh ${TS}/config/config_001_pretty.json > ${TARGET}
  else
    cp -i ${TS}/config/config_001_pretty.json $TARGET
  fi
	if [[ -d .git ]]; then
		git add -fA $TARGET
		git commit
	fi
fi

