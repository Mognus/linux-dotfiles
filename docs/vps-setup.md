# VPS Setup

Provider: Hetzner Cloud — CAX11 (ARM64, 2 vCPU, 4GB RAM, 40GB SSD, ~4€/month)

## Initial connection

Hetzner automatically places your SSH key in `/root/.ssh/authorized_keys` during server creation.

```bash
ssh root@<server-ip>
```

## System update

```bash
apt update && apt upgrade -y
```

## Create non-root user

```bash
adduser <user>
usermod -aG sudo <user>
rsync --archive --chown=<user>:<user> ~/.ssh /home/<user>
```

## Harden SSH

Edit `/etc/ssh/sshd_config`:

```
PermitRootLogin no
PasswordAuthentication no
```

```bash
systemctl restart ssh
```

Test login in a new terminal before closing the root session:

```bash
ssh <user>@<server-ip>
```

## UFW

```bash
ufw allow OpenSSH
ufw allow 80
ufw allow 443
ufw enable
```

## DNS

In Hetzner Cloud Console → DNS: set A-Records for `@` and `www` pointing to the server IP.
Nameservers depend on your registrar — manage via their DNS console.

## Nginx

```bash
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
```

Config at `/etc/nginx/sites-available/default`.  
After any edit: `sudo nginx -t && sudo systemctl reload nginx`

### Reverse proxy to Docker containers

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name example.com www.example.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name example.com www.example.com;

    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # API backend
    location /api {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Frontend
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## HTTPS (Let's Encrypt)

```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d example.com -d www.example.com
```

Certbot automatically:
- proves domain ownership to Let's Encrypt
- issues a free SSL certificate (valid 90 days)
- configures Nginx to redirect HTTP → HTTPS
- sets up a cronjob for automatic renewal

Certs at `/etc/letsencrypt/live/<domain>/`

## Architecture

```
Internet → Nginx (80/443, HTTPS) → Docker containers (internal ports)
```

Nginx runs directly on the host as a reverse proxy in front of Docker containers.
