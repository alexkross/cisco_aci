#!/usr/bin/jq -f
#!/usr/bin/env sh
#egrep -v '"pwd": |"key": |"cert": |"identityPrivateKeyContents": |"identityPrivateKeyPassphrase": |"identityPublicKeyContents": |"userPasswd": |"password": |"authKey": |"value": "SES1' $*
## shorter:
#egrep -v '^[[:space:]]*"[[:alpha:]]+":[[:space:]]*"SES1' $*
## both variants are wrong, because does not remove preceding comma if any.
#del(.pwd)|del(.key)|del(.cert)|del(.identityPrivateKeyContents)|del(.identityPrivateKeyPassphrase)|del(.identityPublicKeyContents)|del(.userPasswd)|del(.password)|del(.authKey)
#del(.pwd),del(.key),del(.cert),del(.identityPrivateKeyContents),del(.identityPrivateKeyPassphrase),del(.identityPublicKeyContents),del(.userPasswd),del(.password),del(.authKey)
#del(.value) which begins with "SES1..."
def walk(f):
  . as $in
  | if type == "object" then
      reduce keys_unsorted[] as $key
        ( {}; . + { ($key):  ($in[$key] | walk(f)) } ) | f
  elif type == "array" then map( walk(f) ) | f
  else f
  end;
walk(if type == "object" then del(.pwd)|del(.key)|del(.cert)|del(.identityPrivateKeyContents)|del(.identityPrivateKeyPassphrase)|del(.identityPublicKeyContents)|del(.userPasswd)|del(.password)|del(.authKey) else . end)
# ToDo: improve with test() to filter out .value containing "^SES1"
