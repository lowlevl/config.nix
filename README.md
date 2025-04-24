# Infra

Repository to store and increment on my IaC on k3s for self hosting services.

## Requirements

- A server provisionned with a recent `k3s` server/cluster, see below.
- An up-to-date `tofu` binary to apply this configuration to the said server.
- A local SSH key already provisionned for this server to allow SSH port forwarding of the
kube-apiserver port to the local machine while applying.

## The node: Raspberry PI 4

- OS: Alpine Linux (3.18)
- Case: DeskPi Pro
- Drive: Kingston DC500M 960GB
- Packages:
    - `openssh`
    - `ufw`
    - `k3s`

### Enable front USB ports

Here is some context from the DeskPi's documentation,
> The front USB function is coming from `dwc2` overlay, it selects the `dwc2` USB controller driver, and `dr_mode` can be `host`, `peripheral` or `otg`. here, `dwc2` mode must be `host`.

So we need to alter the `/boot/usercfg.txt` file to add this line:
```
dtoverlay=dwc2,dr_mode=host
```

Changes will be applied after reboot.

### Enable the CPU fan at fixed speed

> ⚠️ You need to enable **front USB ports** as described earlier, the CPU fan is hooked up to the front hub.

Create file `/etc/local.d/99-cpufan.start` and make it executable with the following contents:
```
echo 'pwm_080' > /dev/ttyUSB0
```

> ℹ️ You can change the speed by using a different speed percentage prefixed by `pwm_`, in example `pwm_100` means 100% and `pwm_012` means 12%.

Then, enable `/etc/local.d` scripts at startup:
```
$ rc-update add local default
```

### Setting up automatic updates on Alpine

We're going to be using the `/etc/periodic` facility, and for this I settled on doing `daily` updates.

To setup the daily `apk` upgrades, we create a file called `/etc/periodic/daily/apk-autoupgrade` with the content
```
#!/bin/sh

apk upgrade --update | sed "s/^/[`date`] /" >> /var/log/apk-autoupgrade.log
```

Finally we just have to make the file executable by running
```
$ chmod +x /etc/periodic/daily/apk-autoupgrade
```

### Setting up the `k3s` cluster on Alpine

Install `k3s` on the node by issuing the following command
```
$ apk add k3s
```

To allow `k3s` to function correctly, we also need to add `cgroup_memory=1 cgroup_enable=memory` to the `/boot/cmdline.txt` file to enable `cgroups`.

Altering the `k3s` configuration can be done by editing `/etc/conf.d/k3s`, and specifying some `K3S_OPTS`, mine are
```
K3S_OPTS="--disable=servicelb --disable-cloud-controller --secrets-encryption"
```
- `--disable=servicelb` is used there because it sometimes shadows real IP addresses to the services,
notably making Traefik unaware of the client's IP address.
- `--disable-cloud-controller` is specified to remove the overhead of having this component I won't use.
- `--secrets-encryption` is specified to enable secrets encryption at rest.

Then we can enable the service, and **reboot** to apply the `cmdline` and start `k3s`
```
$ rc-update add k3s
$ reboot
```

If you happen to have `ufw` installed, _which I have_, you should also allow in-cluster communication:
```
$ ufw allow from 10.42.0.0/16 to any # allow ingress from pods
```

After rebooting, we can confirm everything worked by issuing
```
$ kubectl get node -o wide
```

### Setting up the incremental backups using `rdiff-backup`

Install the `rdiff-backup` utility
```
$ apk add rdiff-backup
```

Our incremental backups will be saved in `/var/backup`, so we create the directory and setup the permissions
```
$ mkdir /var/backup
$ chmod 600 /var/backup
```

Then the backup is going to be using the `/etc/periodic` facility, and for this I settled on doing `hourly` backups.

To setup the hourly backup, we're going to create a new file called `/etc/periodic/hourly/volume-backups` with the following content
```
#!/bin/sh

LOGFILE="/var/log/volume-backups.log"
BACKLOG="2W" # keep two weeks of backups

SOURCE="/var/lib/rancher/k3s/storage"
DESTINATION="/var/backup/volume-backups"

# Ensure the destination directory exists
mkdir -p "$DESTINATION"

rdiff-backup --api-version 201 remove increments --older-than "$BACKLOG" "$DESTINATION" 2>&1 | sed "s/^/[`date`] /" >> $LOGFILE
rdiff-backup --api-version 201 backup --print-statistics "$SOURCE" "$DESTINATION" 2>&1 | sed "s/^/[`date`] /" >> $LOGFILE
```

Finally we just have to make the file executable by running
```
$ chmod +x /etc/periodic/hourly/volume-backups
```

### Setup a `git-annex` an encrypted remote for data storage

#### Server-side configuration

Install `git-annex`, `cryptsetup` and `gpg` on the server
```
$ apk add git-annex cryptsetup gpg 
```

Create a user named `librarian` to hold our annex(es)
```
$ useradd --system --create-home --password '*' --shell /usr/bin/git-annex-shell librarian
```



Set the git configuration up and create the `library.git` annex
```
$ su -s /bin/ash -l librarian -c 'git config --global user.name "Librarian"'
$ su -s /bin/ash -l librarian -c 'git init --bare library.git'
Initialized empty Git repository in /home/librarian/library.git/
```

Authorize our public key to only access the `library.git` annex only using the environment settings of `git-annex-shell` and the `restrict` setting of OpenSSH by adding this line to the `.ssh/authorized_keys` file of the user (replacing `<key>` with yours)
```
environment="GIT_ANNEX_SHELL_LIMITED=true",environment="GIT_ANNEX_SHELL_DIRECTORY=~/library.git",restrict <key>
```

#### Client-side configuration

```
$ pamac install git-annex
```

- Create your local annex

```
$ mkdir ~/Library && cd ~/Library
$ git init
$ git annex init
$ git config set annex.sshcaching true
```

```
$ git annex initremote library.zion.internal type=rsync rsyncurl=librarian@s.unw.re:library.rsync encryption=hybrid keyid=virtual+xps-15-9500@unw.re --with-url

$ git annex enableremote library.zion.internal keyid+=<another-key>

$ git config remote.library.zion.internal.annex-rsync-transport "ssh -p 223"
$ git config remote.library.zion.internal.annex-allow-encrypted-gitrepo true
```

```
$ git annex assistant --autostart
```
