# Part 2

My solutions to [Devops with Docker - part 2](https://devopswithdocker.com/part2/)




## Exercise 2.1

Create a docker-compose.yml file that starts `devopsdockeruh/first_volume_exercise` and saves the logs into your filesystem.

i.e. We just need a bind-mount.

* [ex2.1/docker-compose.yml](ex2.1/docker-compose.yml)

Once present:

```
frodo ~ $ touch logs.txt
frodo ~ $ docker-compose up
Starting ex21_ex2-1_1 ... done
Attaching to ex21_ex2-1_1
ex2-1_1  | (node:1) ExperimentalWarning: The fs.promises API is experimental
ex2-1_1  | Wrote to file /usr/app/logs.txt
ex2-1_1  | Wrote to file /usr/app/logs.txt
^CGracefully stopping... (press Ctrl+C again to force)
Stopping ex21_ex2-1_1 ... done

frodo $ cat logs.txt
Sat, 18 Apr 2020 06:29:15 GMT
Sat, 18 Apr 2020 06:29:18 GMT
```


## Exercise 2.2

Create a `docker-compose.yml` and use it to start the service so that you can use it with your browser.

i.e. Here we configure port-binding.


* [ex2.2/docker-compose.yml](ex2.2/docker-compose.yml)

Once present:

```
frodo $ docker-compose up -d
Starting ex22_ex2-2_1 ... done

frodo $ curl http://localhost:8080/
Ports configured correctly!!
```


## Exercise 2.3

* Configure the backend and frontend from part 1 to work in docker-compose.

Here we have to define **two** containers in the single compose file, the solution is here:

* [ex2.3/docker-compose.yml](ex2.3/docker-compose.yml)
  * This file uses the two images I created for [ex1.12](https://github.com/skx/devopswithdocker.com/tree/master/part1#exercise-112)
  * i.e. An image named "backend" on port 8000
  * i.e. An image named "front" on port 5000

Start like so:

```
frodo $ docker-compose up -d
Creating network "ex23_default" with the default driver
Creating ex23_ex2-3-backend_1 ... done
Creating ex23_ex2-3-front_1   ... done
frodo $
```

Test like so:

```
$ curl http://127.0.0.1:5000/
<!DOCTYPE html>
<html lang="en">
..
frodo $ curl 127.0.0.1:8000
Port configured correctly, generated message in logs.txt
..

```


## Exercise 2.4

* Clone https://github.com/docker-hy/scaling-exercise
  * Scale so it works

No change required to the `docker-compose.yml` file, instead I just launched like so:

```
frodo $ docker-compose up --scale compute=2
Starting load-balancer              ... done
Starting scaling-exercise_compute_1 ... done
Starting calculator                 ... done
Creating scaling-exercise_compute_2 ... done
Attaching to calculator, load-balancer, scaling-exercise_compute_1, scaling-exercise_compute_2
```

From the terminal I see :

```
frodo $ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                    NAMES
68945311ff7e        compute             "docker-entrypoint.s…"   About a minute ago   Up About a minute   3000/tcp                 scaling-exercise_compute_2
9b93d9bc6731        compute             "docker-entrypoint.s…"   2 minutes ago        Up About a minute   3000/tcp                 scaling-exercise_compute_1
906518e62997        load-balancer       "/app/docker-entrypo…"   2 minutes ago        Up About a minute   0.0.0.0:80->80/tcp       load-balancer
b66682b8a24e        calculator          "docker-entrypoint.s…"   2 minutes ago        Up About a minute   0.0.0.0:3000->3000/tcp   calculator
```

From my browser, http://localhost:3000`, I see:

```
Your aim is to get the bottom bar to fill before the first depletes!
Congratulations!
```


## Exercise 2.5

* Add redis to the backend-setup

Here we have to do two things:

* Add a redis container.
* Configure the backend container so it can talk to it.

The solution can be found here:

* [ex2.5/docker-compose.yml](ex2.5/docker-compose.yml])
  * Obviously this builds upon the solution in [ex2.3/](ex2.3/)
  * Just adds the new redis-image/instance, and the environmental variable.
  * **Note** I didn't rename the instances, so they still refer to 2.3

Start like so:

```
frodo $ docker-compose up -d
Creating network "ex25_default" with the default driver
Pulling redis (redis:)...
latest: Pulling from library/redis
123275d6e508: Pull complete
f2edbd6a658e: Pull complete
66960bede47c: Pull complete
533694cb3638: Pull complete
1dc100dcb2f1: Pull complete
9ca9ac709269: Pull complete
Creating ex25_ex2-3-front_1   ... done
Creating ex25_ex2-3-backend_1 ... done
Creating ex25_redis_1         ... done
```

Test via the browser-button on 127.0.0.1:5000:

* Exercise 2.5: Working! It took 0.015 seconds.



## Exercise 2.6

* Add database to backend application too.

We build upon the ex2.3 & ex2.5 solutions to add a postgresql instance

* [ex2.6/docker-compose.yml](ex2.6/docker-compose.yml])
  * Obviously this builds upon the solution in [ex2.3/](ex2.3/)
  * Obviously this builds upon the solution in [ex2.5/](ex2.5/)
  * **Note** I didn't rename the instances, so they still refer to 2.3

Starting launches as expected:

```
frodo $ docker-compose up -d
Creating ex26_ex2-3-front_1   ... done
Creating ex26_ex2-3-backend_1 ... done
Creating ex26_redis_1         ... done
Creating ex26_psql_1          ... done
```

Testing via the browser UI shows persistence works:

* Enter "Foo" into Ex 2.6 field, then click "Send Message"
* Reload page, then click "Get All Messages"



## Exercise 2.7

* Configure a machine learning project.

TODO


## Exercise 2.8

* Add nginx to example frontend + backend.

TODO


## Exercise 2.9

* Configure bind-mount/volumes for psql.

TODO


## Exercise 2.10

* Ensure you can press all the buttons in the front-end (?)

TODO
