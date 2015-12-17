#!/bin/bash

docker build -t "alpine-builder" .
docker run --rm -it -e RSA_PRIVATE_KEY="$(cat ./your-rsa-key.rsa)" -v $(pwd)/your-rsa-key.rsa.pub:/etc/apk/keys/abuild.rsa.pub -v $(pwd):/home/builder/package -v $(pwd)/packages:/home/builder/packages "alpine-builder"
