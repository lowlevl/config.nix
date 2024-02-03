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

### Setting up the k3s cluster on Alpine

Install `k3s` on the node by issuing the following command
```
$ apk add k3s
```

To allow `k3s` to function correctly, we also need to the `cgroup_memory=1 cgroup_enable=memory` to the `/boot/cmdline.txt` file.

Altering the k3s configuration can be done by editing `/etc/conf.d/k3s`, and specifying some `K3S_OPTS`, mine are
```
K3S_OPTS="--disable=servicelb --disable-cloud-controller"
```
- `--disable=servicelb` is used there because it sometimes shadows real IP addresses to the services,
notably making Traefik unaware of the client's IP address
- `--disable-cloud-controller` is specified to remove the overhead of having this component I won't use

Then we can enable the service, and reboot to apply the `cmdline` and start `k3s`
```
$ rc-update add k3s
$ reboot
```

After rebooting, we can confirm everything worked by issuing
```
$ kubectl get node -o wide
```
