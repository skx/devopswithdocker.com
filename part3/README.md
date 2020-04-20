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

(Via `docker images ls -s`)

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

TODO




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
| front  | 345Mb |   436Mb |
| backend| 165MB |   269Mb |


* I didn't need to install node, obviously.
* Still added, & removed, `git` to clone the projects.
* The biggest change here is probably that I didn't have the recursive chown ..
  * As this is running as root.  Not the `server` user.

TODO:

* Re-Add the user and chown.




# Exercise 3.6

* Lets do a multi-stage build for the frontend project since we’ve come so far with the application.

The Dockerfile can be found in [ex3.6/](ex3.6/), which largely does the same setup as previously, but then copies the `dist/` contents into place.

New size is `124Mb`:

```
frodo ~/x/part3/ex3.6 $ docker image ls | head -n 2
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
frontend            latest              c906d1578b96        59 seconds ago      124MB
```

TODO:

* Re-Add the user and chown.




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

* Diagram drawing.  (WTF?)

TODO
