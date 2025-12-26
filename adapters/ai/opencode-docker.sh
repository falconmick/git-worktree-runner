#!/usr/bin/env bash
# OpenCode adapter

# Check if OpenCode (docker) is available
ai_can_start() {
  command -v docker >/dev/null 2>&1
}

# Start OpenCode (docker) in a directory
# Usage: ai_start path [args...]
ai_start() {
  local path="$1"
  shift

  if ! ai_can_start; then
    log_error "Docker not found. Install from https://docs.docker.com/engine/install"
    log_info "Make sure the 'docker' CLI is available in your PATH"
    return 1
  fi

  if [ ! -d "$path" ]; then
    log_error "Directory not found: $path"
    return 1
  fi

  # Change to the directory and run opencode in Docker with any additional arguments
  (
    cd "$path" &&
      docker run -it --rm \
        -v "$PWD:/workspace" \
        -v "$HOME/.local/share/opencode:/root/.local/share/opencode" \
        -w /workspace \
        ghcr.io/sst/opencode \
        "$@"
  )
}
