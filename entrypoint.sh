
#!/usr/bin/env sh

set -e

main() {
  [ -z "$RSA_PRIVATE_KEY" ] && echo "You need to set RSA_PRIVATE_KEY environent variable" && exit 1
  echo "$RSA_PRIVATE_KEY" > /home/builder/abuild.rsa
  mkdir -p /home/builder/packages
  for d in main/*
  do
    ( cd $d && abuild-apk update && abuild -r )
  done
}

main "$@"

