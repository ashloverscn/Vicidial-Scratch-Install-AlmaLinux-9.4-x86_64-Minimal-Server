#!/bin/bash

service=$@asterisk
/bin/systemctl -q is-active "$service.service"
status=$?
if [ "$status" == 0 ]; then
    echo "$status"
    echo "OK"
else
    /bin/systemctl restart "$service.service"
fi
