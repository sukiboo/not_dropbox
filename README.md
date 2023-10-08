# Not Dropbox
A simple bash script that uses `rsync` and `sshpass` to sync files between two directories if the conventional tools like Dropbox, Google Drive, OneDrive are not available.
This script allows directory syncronization between two machines: `SERVER` and `CLIENT`, and can be used for manual or automated two-way file backups.


## Setup
Both `SERVER` and `CLIENT` machines must have `ssh`, `sshpass`, and `rsync` installed, which they likely already have.

The script expects the following shell variables, defined in `./config`:
- `SSHPASS_PATH` -- path to `sshpass` on `SERVER`, probably `/usr/local/bin/sshpass`
- `RSYNC_PATH` -- path to `rsync` on `SERVER`, probably `/usr/bin/rsync`
- `SERVER_DIR` -- path to the sync directory on `SERVER`
- `CLIENT_DIR` -- path to the sync directory on `CLIENT`
- `CLIENT_IP` -- ip address of `CLIENT`, must be in the local network
- `CLIENT_PASS` -- password required to ssh to `CLIENT` (if any)

How/where the `config` file is stored is up to your security/convenience prefernces, but keep in mind that any program that has access to `config` essentially has access to the `CLIENT` machine.
Since my `CLIENT` is a toaster that does not store any sensitive info, I just keep `config` in the script directory, but this is generally frowned upon.


## How It Works
The script is run on the `SERVER` machine and its execution consists of three action:
1. pull new files from `CLIENT` and replace the modified ones
2. remove files on `SERVER` marked for deletion with `~`
3. push files to `CLIENT` and delete the files that are not on `SERVER`

That way each machine is able to add/modify/remove files.

#### Adding Files
To add new files, just put them in the sync directory on either `SERVER` or `CLIENT` machine.
New and modified files will be synced during the next script execution.
Any modified file will replace its original version; in case of conflict, the most recent version will be saved.

#### Removing Files
Deleting files is a bit more nuanced since just deleting will not work -- as long as a file exists on either `SERVER` or `CLIENT` machine, it will be copied to both.
In order to be removed, the files/directories must be manually marked for deletion by appending `~` to the file name, i.e.
```
file_to_remove.ext -> file_to_remove~.ext
dir_to_remove -> dir_to_remove~
```
Files/directories marked with a trailing tilde will be delete from both `SERVER` or `CLIENT` during the next script execution.

Such a way of deletion fits the backup needs as it greatly reduces the chance of files being delete by accident.
However, if a more conventional deletion is preferred, one can look into [rsync-continuous repo](https://github.com/mikkorantalainen/rsync-continuous).


## How to Run
Once the script is set up, you can run it manually when the syncronization is needed or bind it to a shortcut.\
Alternatively, if you require a more persistent syncronization, set up a `cron job`.

For instance, I run it every 5 minutes in `crontab` via
```bash
*/5 * * * * cd /path/to/script/ && bash script.sh >> logs
```
