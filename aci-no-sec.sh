#!/usr/bin/env sh
#egrep -v '"pwd": |"key": |"cert": |"identityPrivateKeyContents": |"identityPrivateKeyPassphrase": |"identityPublicKeyContents": |"userPasswd": |"password": |"authKey": |"value": "SES1' $*
egrep -v '^[[:space:]]*"[[:alpha:]]+":[[:space:]]*"SES1' $*
