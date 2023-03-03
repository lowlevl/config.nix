# Infra

Repository to store and increment on my IaC on k3s for self hosting services.

## Requirements

- A server provisionned with a recent `k3s` server/cluster.
- An up-to-date `terraform` binary to apply this configuration to the said server.
- A local SSH key already provisionned for this server to allow SSH port forwarding of the
kube-apiserver port to the local machine while applying.
