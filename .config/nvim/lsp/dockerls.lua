-- Works without Docker installed, unlike Docker's own docker-language-server,
-- which needs `docker buildx` for its Dockerfile lint.
return {
    cmd = { "docker-langserver", "--stdio" },
    filetypes = { "dockerfile" },
    root_markers = { "Dockerfile", ".git" },
}
