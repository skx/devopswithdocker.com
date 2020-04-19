# Part 3

My solutions to [Devops with Docker - part 3](https://devopswithdocker.com/part3/)




## Exercise 3.1

* Take the backend/frontend images, and make smaller.

In exercise [1.12](https://github.com/skx/devopswithdocker.com/tree/master/part1/ex1.12) I made images for the front-end and back-end:

```
$ cd part1/ex1.12
$ docker build -f Dockerfile.back  -t backend .
$ docker build -f Dockerfile.front -t front .
```

After doing that I see the following image-sizes:

| Image     | Size  |
| --------- | ----- |
| backend   | 411MB |
| front     | 590MB |

(Via `docker images ls -s`)

With the new Dockerfiles present in [ex3.1/](ex3.1/) I managed to achieve some space-saving:

| Image     | Size  |
| --------- | ----- |
| backend   | 408MB |
| front     | 588MB |

The changes were simple enough:

* Join together the various shell-commands to remove layers.
* Purge `git-core` / `curl` after they're used.

TODO:

* `apt-get clean`
* rm -rf /usr/share/doc ? ;)


# Exercise 3.2

* Let’s create our first deployment pipeline!

TODO



# Exercise 3.3

* Build an image within docker.

TODO




# Exercise 3.4

* Run our front-end and back-end images as a non-root user.

Updated dockerfiles contained in [ex3.4/](ex3.4/), with two changes:

* Added the user `adduser server`
* Added the `USER server` to the dockerfile.

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

| Image  | Size  |
| ------ | ----- |
| front  | 345Mb |
| backend| 165MB |


* I didn't need to install node, obviously.
* Still added, & removed, `git` to clone the projects.
* The biggest change here is probably that I didn't have the recursive chown ..
  * As this is running as root.  Not the `server` user.




# Exercise 3.6

* Lets do a multi-stage build for the frontend project since we’ve come so far with the application.

The Dockerfile can be found in [ex3.6/](ex3.6/), which largely does the same setup as previously, but then copies the `dist/` contents into place.

New size is `124Mb`:

```
frodo ~/x/part3/ex3.6 $ docker image ls | head -n 2
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
frontend            latest              c906d1578b96        59 seconds ago      124MB
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

The image has a dedicated user to run the server as, and while it could have been smaller there was the issue of deploying the binary with libc/library differences so the run-time layer is Debian Buster to match the golang-based build-layer.



# Exercise 3.8

* Diagram drawing.  (WTF?)

TODO
