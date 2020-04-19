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
| front     | 408MB |

The changes were simple enough:

* Join together the various shell-commands to remove layers.
* Purge `git-core` / `curl` after they're used.



# Exercise 3.2

* Let’s create our first deployment pipeline!

TODO



# Exercise 3.3

* Build an image within docker.

TODO




# Exercise 3.4

* Run something as a non-root user.

TODO




# Exercise 3.5

* Take the backend/frontend images from [ex2.10](https://github.com/skx/devopswithdocker.com/tree/master/part2#exercise-210) and use the NodeJS base image instead.
  * Will make smaller.

TODO




# Exercise 3.6

* Lets do a multi-stage build for the frontend project since we’ve come so far with the application.

TODO



# Exercise 3.7

* Do all or most of the optimizations from security to size for any other Dockerfile you have access to.

In my case I'll use the [http-server](https://github.com/skx/httpd) I hacked up, which has a Dockerfile published for [exercise 1.15](https://github.com/skx/devopswithdocker.com/tree/master/part1#exercise-115).

TODO




# Exercise 3.8

* Diagram drawing.  (WTF?)

TODO
