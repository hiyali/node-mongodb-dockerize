#!/bin/bash

# mongo
# (mongod --fork --dbpath /hunt/db --port 27188 --logpath /hunt/log/mongod.log) & # background
(mongod --dbpath /hunt/db --port 27188 --logpath /hunt/log/mongod.log --smallfiles) &

# run crawler & api
# (cd /hunt/crawler && npm start) & # equal crawl & api
(cd /hunt/crawler && npm run crawl) &
(cd /hunt/crawler && npm run api) &

# admin server
(http-server -p 80 -P http://crawler_docker_container:5555 /hunt/admin/dist) &

# daily job
((crontab -l; echo "0 3 * * * cd /hunt/crawler/ && npm run crawl 2>&1 >> /hunt/log/daily-crawl.log") | crontab -) &
(service cron start) &
