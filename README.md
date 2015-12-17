# alpine-jazz-hands
Docker image for building alpine (apk) packages for your alpine repo. It's easy and nice, and everyone can do it.

# Intro
If you have been using docker for a while, you may be getting sick of the massive ubuntu/debian/centos docker images.
Alpine is a small and nimble Linux distribution, but it may not have all the packages you want.

With this project, you can build your own packages for Alpine Linux! 

# Doing things

Clone this repo.
```
Git clone https://github.com/madedotcom/alpine-jazz-hands.git && cd alpine-jazz-hands
```

Next, you will need to generate some RSA keys so you can sign your packages:
```
docker run --name keys --entrypoint abuild-keygen -e PACKAGER="Your Name <yourname@aol.com>" andyshinn/alpine-abuild -n
```

You should see some output like this:

```
writing RSA key
>>> 
>>> You'll need to install /home/builder/.abuild/yourname@aol.com-6564e4e0.rsa.pub into 
>>> /etc/apk/keys to be able to install packages and repositories signed with
>>> /home/builder/.abuild/ops@made.com-6564e4e0.rsa
>>> 
>>> You might want add following line to /home/builder/.abuild/abuild.conf:
>>> 
>>> PACKAGER_PRIVKEY="/home/builder/.abuild/yourname@aol.com-6564e4e0.rsa"
>>> 
>>> 
>>> Please remember to make a safe backup of your private key:
>>> /home/builder/.abuild/yourname@aol.com-6564e4e0.rsa
>>> 
```

Copy the keys from the keys container to the `alpine-jazz-hands` directory (if you haven't cd'ed to anywhere else, you should still be in `alpine-jazz-hands`).

```
docker cp keys:/home/builder/.abuild/yourname@aol.com-*.rsa.pub .
docker cp keys:/home/builder/.abuild/yourname@aol.com-*.rsa .
```

It is more useful to rename the keys:
```
mv yourname@aol.com-6564e4e0.rsa your-rsa-key.rsa
mv yourname@aol.com-6564e4e0.rsa.pub your-rsa-key.rsa.pub
```


Delete the fake empty package directory and the empty file in there.
```alpine-jazz-hands/main/PACKAGE```


This example will assume you are building a package called `pongo-blender`

Create a directory for your package.
```mkdir main/pongo-blender```
Place your `APKBUILD` file (and any patches) in `alpine-jazz-hands/main/pongo-blender` directory.

*OR* You can even do this:

```
cd main && git clone https://github.com/madedotcom/alpine-pongo-blender.git
```

Update the `abuild.conf` file, `PACKAGER="giddy@made.com"` with `PACKAGER="yourname@aol.com"` .

Build it, assuming that you are in the `alpine-jazz-hands` root directory.
```
docker build -t "alpine-jazz-hands" .
```


Run it (notice that we are using the keys generated, and mounting them inside the container).
```
docker run --rm -it -e RSA_PRIVATE_KEY="$(cat ./your-rsa-key.rsa)" -v $(pwd)/your-rsa-key.rsa.pub:/etc/apk/keys/abuild.rsa.pub -v $(pwd):/home/builder/package -v $(pwd)/packages:/home/builder/packages "alpine-jazz-hands"
```

The container will run, build the package and then exit, and then remove itself.
You should have your Alpine Linux APK package in `packages/main/x86_64/`.


# Caveats and things
This will loop over all directories in `alpine-jazz-hands/main` and will attempt to build alpine packages for everything it finds.

If things fail for one package, everything should fail.

If you want to troubleshoot things inside the container try something like this.

```
docker build -t "alpine-jazz-hands" .
```

```
docker run -it -e RSA_PRIVATE_KEY="$(cat ./your-rsa-key.rsa)" --entrypoint sh --user root -v $(pwd)/your-rsa-key.rsa.pub:/etc/apk/keys/abuild.rsa.pub -v $(pwd):/home/builder/package -v $(pwd)/packages:/home/builder/packages "alpine-jazz-hands"
```

Please note, that the entrypoint will not have run, and you can't build packages as root.

