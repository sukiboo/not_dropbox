#!/bin/bash

# read the config file
source ./config

# pull from client
RSYNC_PULL_FLAGS="-cavu --exclude='.*'"
$SSHPASS_PATH -p $CLIENT_PASS $RSYNC_PATH $RSYNC_PULL_FLAGS $CLIENT_IP:$CLIENT_DIR $SERVER_DIR

# remove files marked for deletion: 'file~.ext' -> 'file.ext' -> delete
cd "$SERVER_DIR"
IFS=$'\n'
files_to_delete=( $(find . -name '*~.*' -or -name '*~' | sed 's|^\./||') )

for filename in "${files_to_delete[@]}"
do

    # check if the file still exists
    if [ -e "$filename" ]
    then

        # if the file has an extension, remove 'file~.ext' and 'file.ext'
        if [[ "$filename" == *.* ]]
        then
            filename_without_last_tilde="${filename%~*}.${filename#*.}"
            if [ -e "$filename_without_last_tilde" ]
            then
                rm "$filename" "$filename_without_last_tilde"
                echo "deleted $filename and $filename_without_last_tilde"
            else
                rm "$filename"
                echo "deleted $filename"
            fi

        # if the file does not have extension, remove 'file~' and 'file'
        else
            filename_without_last_underscore="${filename%~*}"
            if [ -e "$filename_without_last_tilde" ]
            then
                rm -r "$filename" "$filename_without_last_tilde"
                echo "deleted $filename and $filename_without_last_tilde"
            else
                rm -r "$filename"
                echo "deleted $filename"
            fi
        fi

    fi
done
IFS=$' \t\n'

# push to client and delete files that are not on server
RSYNC_PUSH_FLAGS="-cavu --delete --exclude='.*'"
$SSHPASS_PATH -p $CLIENT_PASS $RSYNC_PATH $RSYNC_PUSH_FLAGS $SERVER_DIR $CLIENT_IP:$CLIENT_DIR

