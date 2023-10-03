#!/bin/bash

# read config file
echo $(date)
source /Users/suki/scripts/config

# pull from client
$SSHPASS_PATH -p $CLIENT_PASS $RSYNC_PATH -cavu $CLIENT_IP:$CLIENT_DIR $SERVER_DIR

# push to client
$SSHPASS_PATH -p $CLIENT_PASS $RSYNC_PATH -cavu --delete $SERVER_DIR $CLIENT_IP:$CLIENT_DIR

