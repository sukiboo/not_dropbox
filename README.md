# Not Dropbox
A simple bash script that uses `rsync` and `sshpass` to sync files between two directories if the conventional tools like Dropbox, Google Drive, OneDrive are not available.

## How It Works
This script allows directory syncronization between two machines: `SERVER` and `CLIENT`.\
The script is run on the `SERVER` machine and consists of two action:
1. pull new files from `CLIENT` and replace the modified ones
2. push files to `CLIENT` and delete the files that are not on `SERVER`

That way each machine is able to add/modify files, but only `SERVER` can delete files.

## Setup
Both `SERVER` and `CLIENT` machines must have `ssh`, `sshpass`, and `rsync` installed, which they likely already have.

Otherwise, the script expects the following shell variables:
- `SERVER_DIR` -- path to the sync directory on `SERVER`
- `CLIENT_DIR` -- path to the sync directory on `CLIENT`
- `CLIENT_IP` -- ip address of `CLIENT`
- `CLIENT_PASS` -- password required to ssh to `CLIENT` (if any)

How/where these varibles are stored is up to your security/convenience prefernses as any program that has access to them essentially has access to the `CLIENT` machine.
Since my `CLIENT` is a toaster and does not store any sensitive info, I just keep these variables in `.bashrc`, but this is generally frowned upon.

## Automating
Once the script is set up, you can run it manually by e.g. binding it to a shortcut.\
Or, if you require a more continuous syncronization, set up a `cron job`.
