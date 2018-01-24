#!/usr/bin/jq -f
def walk(f):
  . as $in |
  if type == "object" then
      reduce keys_unsorted[] as $key
        ( {}; . + { ($key):  ($in[$key] | walk(f)) } ) | f
  elif type == "array" then map( walk(f) ) | f
  else f
  end;
walk(
  # wildcard variant like this: if type == "string" and startswith("SES1") then del(.) else . end # maybe null instead of del(.)
  if type == "object" then
    del(.pwd)|del(.key)|del(.cert)|del(.identityPrivateKeyContents)|del(.identityPrivateKeyPassphrase)|del(.identityPublicKeyContents)|del(.userPasswd)|del(.password)|del(.authKey)|
    if has("value") and (.value|type == "string") and (.value|startswith("SES1")) then # shorter did not work: if (.value|startswith("SES1")?) then
      del(.value)
    else .
    end
  else .
  end
)
## Test with:
#echo '{"tmp": 2, "value":"SES1sgls", "var":[]}' | jq 'if has("value") and (.value|type == "string") and (.value|startswith("SES1")) then del(.value) else [., (.value|type)] end'
#{
#  "tmp": 2,
#  "var": []
#}
