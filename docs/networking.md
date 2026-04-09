# Networking Concepts

## Binding addresses

When a program opens a port, it chooses which interface to listen on:

| Address | Meaning |
|---|---|
| `127.0.0.1` | Loopback — only accessible from your own machine, never leaves the kernel |
| `192.168.x.x` | Your LAN IP — reachable by devices in your local network |
| `0.0.0.0` | All interfaces — loopback + LAN + any VPN interface simultaneously |

To expose a local service to your LAN, bind to `0.0.0.0` or your LAN IP directly:

```bash
server --host 0.0.0.0 --port 3000
```

Then allow it through UFW for LAN only:

```bash
sudo ufw allow from 192.168.1.0/24 to any port 3000
```

## Firewall layers at home

Two independent layers protect your machine:

**1. Router NAT** — your router blocks all unsolicited incoming connections by default. Nothing from the internet reaches your machine unless you explicitly set up port forwarding. This is always active without any configuration.

**2. UFW on your machine** — catches anything that does get through (e.g. from your LAN, or if port forwarding is active).

The combination means: even if a service binds to `0.0.0.0`, it's only reachable from the internet if both the router forwards the port AND UFW allows it.

## Docker caveat

Docker writes its own iptables rules and **bypasses UFW entirely**. A container bound to `0.0.0.0:8080` is reachable from your LAN even if UFW has no rule for it.

Fix: always specify the loopback IP when publishing ports locally:

```bash
docker run -p 127.0.0.1:8080:8080 myimage
```

## Useful commands

```bash
ss -tlnp        # show all listening TCP ports + which process
ss -ulnp        # same for UDP
ip addr show    # show all interfaces and their IPs
ip route        # show routing table
```
