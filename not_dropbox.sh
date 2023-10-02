#!/bin/bash

# pull from client
sshpass -p $CLIENT_PASS rsync -cavu $CLIENT_IP:$CLIENT_DIR $SERVER_DIR

# push to client
sshpass -p $CLIENT_PASS rsync -cavu --delete $SERVER_DIR $CLIENT_IP:$CLIENT_DIR

