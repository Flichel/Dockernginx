variable "DOCKER_USERNAME" {
  type    = string
  default = "flichel" # Tu nombre de usuario de Docker Hub
}

variable "REPO_NAME" {
  type    = string
  default = "mi-pagina-web" # Nombre de tu repositorio Docker Hub
}

variable "GITHUB_OWNER" {
  type    = string
  default = "flichel" # Tu nombre de usuario/organización de GitHub para ghcr.io
}

variable "GHCR_REPO_NAME" {
  type    = string
  default = "dockernginx" # Nombre del repositorio en ghcr.io
}

group "default" {
  targets = ["nginx-image"]
}

target "nginx-image" {
  dockerfile = "Dockerfile"
  context    = "."
  tags = [
    "${DOCKER_USERNAME}/${REPO_NAME}:latest",
    "${DOCKER_USERNAME}/${REPO_NAME}:1.0",
    "${DOCKER_USERNAME}/${REPO_NAME}:${{ github.sha }}",
    "ghcr.io/${GITHUB_OWNER}/${GHCR_REPO_NAME}:latest",
    "ghcr.io/${GITHUB_OWNER}/${GHCR_REPO_NAME}:1.0",
    "ghcr.io/${GITHUB_OWNER}/${GHCR_REPO_NAME}:${{ github.sha }}"
  ]
  platforms = [
    "linux/amd64",
    # "linux/arm64" # Descomenta si quieres builds multi-arquitectura
  ]
  push = true # Esto será sobrescrito por la acción de GitHub Actions si es un pull_request
}