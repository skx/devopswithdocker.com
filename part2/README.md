# Part 2



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
