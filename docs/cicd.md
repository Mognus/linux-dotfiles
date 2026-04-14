# Personal Blog — CI/CD

## Architecture

Push to `main` → GitHub Actions → self-hosted runner on Hetzner → `docker compose up --build -d`

**Why self-hosted runner:** Hetzner server is ARM64 (aarch64). GitHub-hosted runners are amd64. Building for arm64 via QEMU emulation on GitHub runners is slow and complex. Running the runner directly on the server builds natively and deploys in one step — no image registry needed.

## How it works

1. Push to `main` triggers the workflow (`.github/workflows/deploy.yml`)
2. Runner checks out repo with submodules (using `GH_PAT` for private submodule access)
3. Copies `~/personal-blog.env` into the checkout directory as `.env`
4. Runs `docker compose -f docker-compose.prod.yml up --build -d`
5. Prunes old images

## Prerequisites

### On the server
```bash
# Install Docker
curl -fsSL https://get.docker.com | sh && sudo usermod -aG docker $USER

# Install GitHub Actions runner (ARM64)
mkdir ~/actions-runner && cd ~/actions-runner
curl -o runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.323.0/actions-runner-linux-arm64-2.323.0.tar.gz
tar xzf runner.tar.gz
./config.sh --url https://github.com/<username>/<repo> --token <TOKEN>
sudo ./svc.sh install && sudo ./svc.sh start

# Place env file
nano ~/personal-blog.env
```

Runner token: GitHub repo → Settings → Actions → Runners → New self-hosted runner

### In GitHub repo secrets
| Secret | Value |
|--------|-------|
| `GH_PAT` | PAT with `repo` scope (for private submodule checkout) |

## personal-blog.env

See `.env.template` in the repo. Change:
- `POSTGRES_PASSWORD` + `DB_PASSWORD` → `openssl rand -base64 32`
- `JWT_SECRET` → `openssl rand -base64 64`
- `CORS_ALLOW_ORIGINS` → actual domain/IP
- `NEXT_PUBLIC_API_URL` → `http://<ip>:8080/api`

## Services

| Container | Port | Notes |
|-----------|------|-------|
| frontend | 3000 | Next.js |
| backend | 8080 | Go API gateway |
| auth-service | 50051 (internal) | gRPC, not exposed |
| postgres | internal | |
| redis | internal | |
