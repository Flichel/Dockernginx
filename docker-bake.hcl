variable "DOCKER_USERNAME" {
  type    = string
  default = "flichel" # <--- ¡IMPORTANTE! Cambia esto a tu nombre de usuario de Docker Hub
}

variable "REPO_NAME" {
  type    = string
  default = "mi-pagina-web" # <--- ¡IMPORTANTE! Cambia esto al nombre de tu repositorio en Docker Hub
}

variable "GITHUB_OWNER" {
  type    = string
  default = "flichel" # <--- ¡IMPORTANTE! Cambia esto a tu nombre de usuario o el de tu organización de GitHub
}

variable "GHCR_REPO_NAME" {
  type    = string
  default = "dockernginx" # <--- ¡IMPORTANTE! Cambia esto al nombre de tu repositorio en GHCR
}

# --- ¡Aquí NO va la definición de variable "GIT_SHA" si se pasa como build-arg! ---

group "default" {
  targets = ["nginx-image"]
}

target "nginx-image" {
  dockerfile = "Dockerfile"
  context    = "."
  tags = [
    "${DOCKER_USERNAME}/${REPO_NAME}:latest",
    "${DOCKER_USERNAME}/${REPO_NAME}:1.0",
    "${DOCKER_USERNAME}/${REPO_NAME}:{{.BuildArgs.GIT_SHA_TAG}}", # <--- ¡CAMBIO AQUÍ! Usa la sintaxis BuildArgs
    "ghcr.io/${GITHUB_OWNER}/${GHCR_REPO_NAME}:latest",
    "ghcr.io/${GITHUB_OWNER}/${GHCR_REPO_NAME}:1.0",
    "ghcr.io/${GITHUB_OWNER}/${GHCR_REPO_NAME}:{{.BuildArgs.GIT_SHA_TAG}}" # <--- ¡CAMBIO AQUÍ!
  ]
  platforms = [
    "linux/amd64",
    # "linux/arm64"
  ]
  push = true
}