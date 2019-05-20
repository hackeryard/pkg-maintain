#!/bin/bash

echo "stoping all..."

ps -ef | grep hydra | awk '{print $2}' | xargs kill -9
ps -ef | grep www | awk '{print $2}' | xargs kill -9
ps -ef | grep manage | awk '{print $2}' | xargs kill -9

sleep 3

echo "starting all"

nohup /root/hydra/login-config/start_server_postgre.sh > hydra.log 2>&1 &

cd /root/login/login-consent-node/ && export HYDRA_ADMIN_URL=http://10.10.26.24:4445 && nohup npm start > login-consent.log 2>&1 &

cd /root/login/loginserver/login && source login/bin/activate && nohup python manage.py  runserver 10.10.26.24:8003 > loginserver.log 2>&1 &

echo "please wait 15 seconds"
sleep 15

cd /root/hydra/login-config && ./start_grafana.sh && ./start_loginserver.sh

