# Part 3

My solutions to [Devops with Docker - part 3](https://devopswithdocker.com/part3/)




## Exercise 3.1

* Take the backend/frontend images, and make smaller.

In exercise 1.12 I'd already made images for the front-end and back-end, so copied those as a starting point:

```
$ cd ex3.1/
$ docker build -f Dockerfile.back.orig  -t backend .
$ docker build -f Dockerfile.front.orig -t front .
```

After doing that I see the following image-sizes:

| File                  | Image     | Size  |
| --------------------- | --------- | ----- |
| Dockerfile.back.orig  | backend   | 411MB |
| Dockerfile.front.orig | front     | 590MB |

(Via `docker image ls`)

With the new Dockerfiles present in [ex3.1/](ex3.1/) I managed to achieve a __small__ amount of space-saving:


| File                  | Image     | Size  | Saving |
| --------------------- | --------- | ----- | ------ |
| Dockerfile.back       | backend   | 588Mb |    2Mb |
| Dockerfile.fron       | front     | 408Mb |    3Mb |

The changes were simple enough:

* Join together the various shell-commands to remove layers.
* Purge `git-core` / `curl` after they're used.
* Remove the `apt` state-files.
* Remove `.git/` contents from the repository we cloned.

**NOTE**: For sneaky extra points I could do something like `rm -rf /usr/share/doc`, but that felt like cheating.




# Exercise 3.2

* Let’s create our first deployment pipeline!

I logged into heroku, and created a new application named `dwd-pipeline`
(dwd -> devops with docker, used the same prefix in part2).

Using their console I configured commits from github to be deployed to production.  Making a commit and push resulted in a working application.

```
frodo ~/Repos/github.com/skx/httpd $ git push heroku master
Counting objects: 29, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (28/28), done.
Writing objects: 100% (29/29), 4.24 KiB | 0 bytes/s, done.
Total 29 (delta 10), reused 0 (delta 0)
remote: Compressing source files... done.
remote: Building source:
remote:
remote: -----> Go app detected
remote: -----> Fetching stdlib.sh.v8... done
remote: ----->
remote:        Detected go modules via go.mod
remote: ----->
remote:        Detected Module Name: github.com/skx/httpd
remote: ----->
remote:  !!    The go.mod file for this project does not specify a Go version
remote:  !!
remote:  !!    Defaulting to go1.12.17
remote:  !!
remote:  !!    For more details see: https://devcenter.heroku.com/articles/go-apps-with-modules#build-configuration
remote:  !!
remote: -----> Using go1.12.17
remote: -----> Determining packages to install
remote:
remote:        Detected the following main packages to install:
remote:        		github.com/skx/httpd
remote:
remote: -----> Running: go install -v -tags heroku github.com/skx/httpd
remote: github.com/skx/httpd
remote:
remote:        Installed the following binaries:
remote:        		./bin/httpd
remote:
remote:        Created a Procfile with the following entries:
remote:        		web: bin/httpd
remote:
remote:        If these entries look incomplete or incorrect please create a Procfile with the required entries.
remote:        See https://devcenter.heroku.com/articles/procfile for more details about Procfiles
remote:
remote: -----> Discovering process types
remote:        Procfile declares types -> web
remote:
remote: -----> Compressing...
remote:        Done: 3.7M
remote: -----> Launching...
remote:        Released v4
remote:        https://dwd-pipeline.herokuapp.com/ deployed to Heroku
remote:
remote: Verifying deploy... done.
To https://git.heroku.com/dwd-pipeline.git
 * [new branch]      master -> master
```

The end result is that pushes to github, or directly to the heroku origin (as defined in `.git/config`) trigger a deployment.

The application is visible here:

* https://dwd-pipeline.herokuapp.com/




# Exercise 3.3

* Build an image within docker.

OK this was a fun one.  The core goal is:

* Take a Github URL
* Clone that, and build the docker file in the root
* Tag it and push to dockerhub.

I created a pair of files:

* [ex3.3/builder](ex3.3/builder)
  * The script that builds the image.
  * It installs `git` and `docker`.
* [ex3.3/Dockerfile](ex3.3/Dockerfile)
  * The dockerfile to create an image of that

Build the builder:

```
frodo ~/x/part3/ex3.3 $ docker build -t builder .
Sending build context to Docker daemon  3.072kB
..
```

Login to dockerhub on the host:

```
frodo ~/x/part3/ex3.3 $ docker login --username=stevekemp
Password:
WARNING! Your password will be stored unencrypted in /home/skx/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store
```

Now launch it to build the image, note that we map two things:

* The docker-socket.
* The docker `config.json` file, so that the push works.


```
$ docker run -ti -v /var/run/docker.sock:/var/run/docker.sock \
                 -v /home/skx/.docker/config.json:/root/.docker/config.json \
                 builder:latest https://github.com/skx/httpd.git

URL https://github.com/skx/httpd.git will be tagged as stevekemp/stevekemp/auto-httpd
Cloning into '/tmp/tmp.ONxN2VTPPZ/git'...
remote: Enumerating objects: 35, done.
remote: Counting objects: 100% (35/35), done.
remote: Compressing objects: 100% (27/27), done.
remote: Total 35 (delta 14), reused 28 (delta 7), pack-reused 0
Unpacking objects: 100% (35/35), done.
Sending build context to Docker daemon  110.6kB
Step 1/9 : FROM golang:1.14.2-buster
 ---> a1c86c07867e
Step 2/9 : RUN apt-get update && apt-get install git-core --yes
 ---> Using cache
 ---> d8b30b0ac7d6
Step 3/9 : RUN mkdir /app
 ---> Using cache
 ---> 995bfb644e3d
Step 4/9 : RUN mkdir /docs
 ---> Using cache
 ---> 6488df810f2c
Step 5/9 : RUN echo 'Hello skx/httpd' > /docs/index.html
 ---> Using cache
 ---> 6263380e6f44
Step 6/9 : RUN cd /app && git clone https://github.com/skx/httpd.git
 ---> Using cache
 ---> 788a9ceae11c
Step 7/9 : RUN cd /app/httpd && go build .
 ---> Using cache
 ---> 8270aaf245cf
Step 8/9 : EXPOSE 3000
 ---> Using cache
 ---> f851451075fd
Step 9/9 : CMD  /app/httpd/httpd -host 0.0.0.0 -path /docs
 ---> Using cache
 ---> fabe21335881
Successfully built fabe21335881
Successfully tagged stevekemp/auto-httpd:latest
The push refers to repository [docker.io/stevekemp/auto-httpd]
daf0e97c32fc: Pushed
068b0183197a: Pushed
ade5410603b8: Pushed
ae4f168f7e99: Pushed
532bf794c9d1: Pushed
3a402b4d79ff: Pushed
feae5ce26f02: Mounted from library/golang
29a23d067e48: Mounted from library/golang
1af88e92b20b: Mounted from library/golang
d35c5bda4793: Mounted from library/golang
a3c1026c6bcc: Mounted from library/golang
f1d420c2af1a: Pushed
461719022993: Mounted from library/golang
latest: digest: sha256:84276f5a9fc62ff68c61c3ecada7ff1502449b2751eee6fd957e24fcb100f83c size: 3046
```

You'll then find the result here:

* https://hub.docker.com/r/stevekemp/auto-httpd
  * Of course no documentation.

Second test to build/tag/push https://github.com/docker-hy/docs-exercise.git:

```
docker run -ti -v /var/run/docker.sock:/var/run/docker.sock -v /home/skx/.docker/config.json:/root/.docker/config.json builder:latest https://github.com/docker-hy/docs-exercise.git
URL https://github.com/docker-hy/docs-exercise.git will be tagged as stevekemp/stevekemp/auto-docs-exercise
Cloning into '/tmp/tmp.USBMBTIjuu/git'...
remote: Enumerating objects: 5, done.
remote: Total 5 (delta 0), reused 0 (delta 0), pack-reused 5
Unpacking objects: 100% (5/5), done.
Sending build context to Docker daemon  60.42kB
Step 1/4 : FROM node:alpine
 ---> bcfeabd22749
Step 2/4 : WORKDIR /usr/app
 ---> Running in 03e431f5daa2
Removing intermediate container 03e431f5daa2
 ---> e77177021935
Step 3/4 : COPY . .
 ---> 5686bbeb575d
Step 4/4 : CMD ["node", "index.js"]
 ---> Running in 95cde9e4ca8f
Removing intermediate container 95cde9e4ca8f
 ---> a262cbfbdcd2
Successfully built a262cbfbdcd2
Successfully tagged stevekemp/auto-docs-exercise:latest
The push refers to repository [docker.io/stevekemp/auto-docs-exercise]
16f714184410: Pushed
a2fed5e933ec: Pushed
00c39a830bf6: Mounted from library/node
9dbc7acbba5b: Mounted from library/node
3cf1f4bf7df5: Mounted from library/node
beee9f30bc1f: Mounted from library/node
latest: digest: sha256:fc873486a995d332c8c410c2e70fd53ab734673a5a881c00c9b5debbeb2e4fd1 size: 1574
```

From there we can clean all our images, and confirm that fetching/running works:

```
frodo ~/x/part3/ex3.3 $ docker run -ti stevekemp/auto-docs-exercise
Unable to find image 'stevekemp/auto-docs-exercise:latest' locally
latest: Pulling from stevekemp/auto-docs-exercise
aad63a933944: Pull complete
3ce96fb50a59: Pull complete
2223b4a743f6: Pull complete
adea9cae4121: Pull complete
4f25e5d9dd11: Pull complete
2704c8e0c75c: Pull complete
Digest: sha256:fc873486a995d332c8c410c2e70fd53ab734673a5a881c00c9b5debbeb2e4fd1
Status: Downloaded newer image for stevekemp/auto-docs-exercise:latest
Give me the password: foo
foo is not the correct password, please try again

Give me the password: bar
bar is not the correct password, please try again

Give me the password: basics
You found the correct password. Secret message is:
"This is the secret message"
```




# Exercise 3.4

* Run our front-end and back-end images as a non-root user.

Updated dockerfiles contained in [ex3.4/](ex3.4/), with two changes:

* Added the user to run the server `adduser server`
* Added the `USER server` to the dockerfile to make that user run later commands.

**NOTE**:

* It would have been better to run the `git clone ..`, and similar commands, as the user.  However installing git would have required root, or sudo.
* I was mostly thinking of the run-time due to bugs in the application, I assume we can trust the system & NPM packages (ha).
* Plus adding these commands at the end allow me to reuse the cached image(s) from ex3.1 :)




# Exercise 3.5

* Use the NodeJS base image instead for our front-end and back-end images.

Resulting dockerfiles contained in [ex3.5/](ex3.5/)

Initial sizes after ex3.4:

| Image  | Size  |
| ------ | ----- |
| front  | 781MB |
| backend| 434MB |

After changing the base to `node:alpine` they become:

| Image  | Size  |  Saving |
| ------ | ----- | ------- |
| front  | 346Mb |   435Mb |
| backend| 166MB |   268Mb |


* I didn't need to install node, obviously.
  * Still added, & removed, `git` to clone the projects.
* I still added the `server` user for both images, and make them run under it.
  * This time I ran the `chown` before the npm install.
  * **NOTE**: Had to change the adduser, via reference:
    * https://github.com/gliderlabs/docker-alpine/issues/38



# Exercise 3.6

* Lets do a multi-stage build for the frontend project since we’ve come so far with the application.

The Dockerfile can be found in [ex3.6/](ex3.6/), which largely does the same setup as previously, but then copies the `dist/` contents into place.

I made sure I readded the user to run the server, for completeness.

```
frodo $ docker build -t front-new .
Sending build context to Docker daemon  3.072kB
..
```

The new/final size is `127Mb`:

```
$ docker image ls front-new | awk '{print $NF}' | tail -n1
127MB

```


# Exercise 3.7

* Do all or most of the optimizations from security to size for any other Dockerfile you have access to.

In my case I'll use the [http-server](https://github.com/skx/httpd) I hacked up, which has a Dockerfile published for [exercise 1.15](https://github.com/skx/devopswithdocker.com/tree/master/part1#exercise-115).

Since this is a Golang binary we can build it nice and neatly via just copying the binary.

* [ex3.7/](ex3.7/) contains the Dockerfile

The size is small:

```
frodo ~/x/part3 $ docker image ls | head -n2
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
httpd               latest              fb3823d6dc78        29 seconds ago       122MB
```

The image has a dedicated `server`-user which launches the application.

This image _could_ have been smaller there was the issue of deploying the binary with libc/library differences so the run-time layer is Debian Buster to match the golang-based build-layer.  (i.e. This failed when I ran on alpine.)



# Exercise 3.8

* Diagram drawing.
