# Part 1



## Exercise 1.1

* Start three containers.
* Stop two of them.
* Show the process-list.

```
frodo ~ $ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                      PORTS               NAMES
e760a03984d4        nginx               "nginx -g 'daemon of…"   8 seconds ago       Exited (137) 1 second ago                       blissful_williamson
47107e25d76a        nginx               "nginx -g 'daemon of…"   9 seconds ago       Exited (137) 1 second ago                       cool_liskov
370c4825b5ac        nginx               "nginx -g 'daemon of…"   10 seconds ago      Up 9 seconds                80/tcp              trusting_williamson
```



## Exercise 1.2

* Clean the docker daemon from all images and containers.
* Submit the output for docker ps -a and docker images


Terminated all containers:
```
frodo ~ $ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
frodo ~ $
```

Removed all images:

```
frodo ~ $ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
```



## Exercise 1.3

* Run `docker run -it devopsdockeruh/pull_exercise`
* Submit the secret message and commands to get it.

```
Give me the password: basics
You found the correct password. Secret message is:
"This is the secret message"
```

* The docker file:
  * https://hub.docker.com/r/devopsdockeruh/pull_exercise/dockerfile
* The source repository:
  * https://github.com/docker-hy/docs-exercise
* The code :
  * https://github.com/docker-hy/docs-exercise/blob/master/index.js
  * `basics` -> `victory()`




## Exercise 1.4

* Start image `devopsdockeruh/exec_bash_exercise`.
* Read the secret message from `./logs.txt`


```
frodo ~ $ docker run -d devopsdockeruh/exec_bash_exercise
9b995503a3307192080b7825683bdc687d5308c3320f365bcce67f1e6fb11ce4

frodo ~ $ docker exec -it 9b995503a3307192080b7825683bdc687d5308c3320f365bcce67f1e6fb11ce4 tail ./logs.txt
..
..
Wed, 15 Apr 2020 08:27:27 GMT
Secret message is:
"Docker is easy"

frodo ~ $ docker kill 9b995503a3307192080b7825683bdc687d5308c3320f365bcce67f1e6fb11ce4
```



## Exercise 1.5

* Run Ubuntu.
* Prompt and fetch a remote URL.

Suspect the answer here is mostly to install curl, but I might have missed somethign:

```
docker run -it ubuntu:16.04 sh -c 'apt-get update --quiet --quiet; \
   apt-get install --yes curl ;\
   echo "Input website:"; \
   read website; \
   echo "Searching.."; \
   sleep 1; \
   curl http://$website;'
```

The output of that works as expected, albeit a lot of noise from the `apt-get` package installation:


```
...
Setting up curl (7.47.0-1ubuntu2.14) ...
Processing triggers for libc-bin (2.23-0ubuntu11) ...
Processing triggers for ca-certificates (20170717~16.04.2) ...
Updating certificates in /etc/ssl/certs...
148 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
Input website:
helsinki.fi
Searching..
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>301 Moved Permanently</title>
</head><body>
<h1>Moved Permanently</h1>
<p>The document has moved <a href="http://www.helsinki.fi/">here</a>.</p>
</body></html>
```




## Exercise 1.6

* Create a Dockerfile..


Result visible as [ex1.6/Dockerfile](ex1.6/Dockerfile), and can be executed
like so:

```
$ cd ex1.6 && docker build -t docker-clock .
Sending build context to Docker daemon  2.048kB
dStep 1/2 : FROM devopsdockeruh/overwrite_cmd_exercise
 ---> 3d2b622b1849
Step 2/2 : CMD ["--clock"]
 ---> Using cache
 ---> 75f7c28d7c87
Successfully built 75f7c28d7c87
Successfully tagged docker-clock:latest
$ docker run docker-clock
1
2
Ctrl-c
```



## Exercise 1.7

* Create a Dockerfile.

Result visible as [ex1.7/Dockerfile](ex1.7/Dockerfile), and can be executed like so:


```
$ cd ex1.7 && docker build -t curler .
$ docker run -it curler
Input website:
helsinki.fi
Searching..
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>301 Moved Permanently</title>
</head><body>
<h1>Moved Permanently</h1>
<p>The document has moved <a href="http://www.helsinki.fi/">here</a>.</p>
</body></html>
```


## Exercise 1.8

* Image `devopsdockeruh/first_volume_exercise` has instructions to create a log into `/usr/app/logs.txt`.
* Start that container with a bind-mount.

Note there are no instructions, but we can guess :)

```
$ touch logs.txt
$ docker run -v $(pwd)/logs.txt:/usr/app/logs.txt devopsdockeruh/first_volume_exercise
(node:1) ExperimentalWarning: The fs.promises API is experimental
Wrote to file /usr/app/logs.txt
Wrote to file /usr/app/logs.txt
Wrote to file /usr/app/logs.txt
Wrote to file /usr/app/logs.txt
Wrote to file /usr/app/logs.txt
Wrote to file /usr/app/logs.txt
Wrote to file /usr/app/logs.txt
Wrote to file /usr/app/logs.txt
Wrote to file /usr/app/logs.txt
^C
```

Now we can see the secret message:

```
cat logs.txt
Wed, 15 Apr 2020 08:50:35 GMT
Wed, 15 Apr 2020 08:50:38 GMT
Wed, 15 Apr 2020 08:50:41 GMT
Wed, 15 Apr 2020 08:50:44 GMT
Secret message is:
"Volume bind mount is easy"
Wed, 15 Apr 2020 08:50:50 GMT
Wed, 15 Apr 2020 08:50:53 GMT
Wed, 15 Apr 2020 08:50:56 GMT
Wed, 15 Apr 2020 08:50:59 GMT
```




## Exercise 1.9

* Map a port to the container HTTP on :80


```
$ docker run -p 2030:80 -d devopsdockeruh/ports_exercise
```

Show it worked:

```
$ curl http://localhost:2030/
Ports configured correctly!!
```