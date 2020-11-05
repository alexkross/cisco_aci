#!/usr/bin/env sh
# Recursively beautify all *.json into *_pretty.json using aci-filename-map.awk. All *_pretty.json are ignored.
# Parameters: <exported_aci_config.tar.gz> [<dest_config_file.json>]
set -e
if [[ -f $1 ]]; then
  TS=$(echo $1 | sed -ne 's/ce2_.*-\(20..-..-..T..-..-..\).tar.gz/\1/p')
	mkdir -p ${TS}_{raw,pretty} && tar -xzf $1 -C ${TS}_raw
	find ${TS}_raw -name \*.json | sed -r 's/([[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2})T([[:digit:]]{2}-[[:digit:]]{2}-[[:digit:]]{2})/\1:\2/g' | aci-filename-map.awk | sh -c '
		while [[ $? -eq 0 ]] && read from to; do
			jq -a --tab '.' < $from > ${0}/${to}.json 2>/dev/null || # fallback to my butifier
                        json-pretty.py < $from | unexpand -t 4 > ${0}/${to}.json 
                        # you may allways use ``| expand -t <tab-width>`` to set desirable indentation
		done
	' "${TS}_pretty" # ToDo: rewrite using plain for loop
	RES=$?
else
	echo 'Bad source path to the exported ACI fabric configuration file (ce*.tar.gz)' 1>&2
	exit 1
fi
set +e
if [[ $RES -eq 0 ]]; then
  if [[ $2 ]]; then
    if [[ ! -d $(dirname $2) ]]; then
      echo "No destination directory for \"$2\" file." 1>&2
      exit 2
    fi
    DEST=$2
  else
    DEST=config.json
  fi
	#rm -i $DEST # for some precautionary interactivity
  if (( ACI_NO_SEC )); then
    aci-no-sec.sh ${TS}_pretty/config_001.json | expand -t 1 > $DEST
  else
    expand -t 1 ${TS}_pretty/config_001.json > $DEST
  fi
  echo Check the result in $DEST, then remove clutter in ${TS}_* !!!
  #cd $(dirname $DEST)
  #DEST=$(basename $DEST)
	#if [[ -d .git ]]; then
		#git add -fA $DEST
		#git commit
	#fi
fi
