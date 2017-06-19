# Nodejs + Phantomjs Crawler on Mongodb dockerization

## Download & Build
```shell
mkdir -p /hunt/db
git clone https://github.com/hiyali/nodejs-mongodb-crontab-dockerize.git
docker build -q -t hunt_crawler:v1 crawler-docker/ # remove -q with outputs
```

## Run background
```shell
docker run -d --restart always -v /hunt/db:/hunt/db:rw --add-host localhost:172.17.0.2 -p 5555:5555 -p 5556:80 --name crawler_container hunt_crawler:v1 /bin/bash -c "/hunt/run.sh"
```

## Run foreground
```shell
docker run -i -t -v /hunt/db:/hunt/db:rw --add-host localhost:172.17.0.2 -p 5555:5555 -p 5556:80 --name crawler_runner_1 hunt_crawler:v1 /bin/bash
./run.sh
```

## Start docker service & Start & Attach ...
```shell
systemctl start docker
docker start crawler_runner_1
docker attach crawler_runner_1
```
> To stop a container, use CTRL-c. This key sequence sends SIGKILL to the container. If --sig-proxy is true (the default),CTRL-c sends a SIGINT to the container. You can detach from a container and leave it running using the CTRL-p CTRL-q key sequence

## docker basic command

#### stop & remove all continaer
```shell
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
```

#### show & remove images
```shell
docker images
docker rmi <image id> # remove a image
docker rmi $(docker images | grep "^<none>" | awk -F ' ' '{print $3}') # remove all none named images
docker rmi $(docker images -q) # remove all images
```

#### command officially documentation
[docker docs](https://docs.docker.com/engine/reference/commandline/build/)

## design
![Crawler design](https://raw.githubusercontent.com/hiyali/nodejs-mongodb-crontab-dockerize/master/assets/crawler_design.png "Crawler design")
