#!/bin/bash

docker build -t "alpine-builder" .
docker run -it -e RSA_PRIVATE_KEY="$(cat ./ops@made.com-5672e4e0.rsa)" -v $(pwd)/ops@made.com-5672e4e0.rsa.pub:/etc/apk/keys/abuild.rsa.pub -v $(pwd):/home/builder/package -v $(pwd)/packages:/home/builder/packages "alpine-builder"
