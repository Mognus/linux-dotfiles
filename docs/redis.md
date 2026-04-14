# Redis

## Start / Autostart

```bash
sudo systemctl enable --now redis   # start + autostart
sudo systemctl start redis          # start only
sudo systemctl stop redis           # stop
sudo systemctl status redis         # status
```

## Reset

```bash
# flush all keys (service keeps running)
redis-cli FLUSHALL

# full reset (delete data files)
sudo systemctl stop redis
sudo rm /var/lib/redis/dump.rdb
sudo systemctl start redis
```

## Docker

```bash
# flush all keys in docker container
docker compose -f docker-compose.dev.yml exec redis redis-cli FLUSHALL
```

## CLI

```bash
redis-cli ping          # PONG if running
redis-cli keys "*"      # list all keys
redis-cli monitor       # live traffic
```
