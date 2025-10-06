#!/bin/bash

service=$@dahdi
/bin/systemctl -q is-active "$service.service"
status=$?
if [ "$status" == 0 ]; then
    echo "$status"
    echo "OK"
else
    modprobe "$service"
    sleep 5
    /bin/systemctl restart "$service.service"
fi
