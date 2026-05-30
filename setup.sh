#!/usr/bin/env bash
set -e

BACKEND_REPO="https://github.com/Personal-Challenge/personal-todo-backend.git"
FRONTEND_REPO="https://github.com/Personal-Challenge/personal-todo-frontend.git"
BRANCH="main"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Error: '$1' no esta instalado o no esta en el PATH." >&2
    exit 1
  fi
}

require_docker_compose() {
  if ! docker compose version >/dev/null 2>&1; then
    echo "Error: 'docker compose' no esta disponible." >&2
    exit 1
  fi
}

clone_or_update() {
  local name="$1"
  local repo="$2"

  if [ -d "$name" ]; then
    if [ ! -d "$name/.git" ]; then
      echo "Error: '$name' existe, pero no es un repositorio Git." >&2
      exit 1
    fi

    echo "Actualizando $name desde $BRANCH..."
    git -C "$name" checkout "$BRANCH"
    git -C "$name" pull origin "$BRANCH"
  else
    echo "Clonando $name desde $BRANCH..."
    git clone --branch "$BRANCH" --single-branch "$repo" "$name"
  fi
}

ensure_env_file() {
  if [ ! -f ".env" ]; then
    echo "Creando .env desde .env.example..."
    cp .env.example .env
  fi
}

require_command git
require_command docker
require_docker_compose

clone_or_update "backend" "$BACKEND_REPO"
clone_or_update "frontend" "$FRONTEND_REPO"
ensure_env_file

echo ""
echo "Setup completo. Ya podes ejecutar:"
echo "docker compose up --build"
