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
  default = "dockernginx" # <--- ¡IMPORTANTE! Cambia esto al nombre de tu repositorio en GHCR (GitHub Container Registry)
}

# Nueva variable para el SHA del commit de Git
variable "GIT_SHA" {
  type    = string
  default = "latest" # Valor por defecto, pero GitHub Actions lo sobrescribirá
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
    "${DOCKER_USERNAME}/${REPO_NAME}:${GIT_SHA}", # Usa la variable GIT_SHA aquí
    "ghcr.io/${GITHUB_OWNER}/${GHCR_REPO_NAME}:latest",
    "ghcr.io/${GITHUB_OWNER}/${GHCR_REPO_NAME}:1.0",
    "ghcr.io/${GITHUB_OWNER}/${GHCR_REPO_NAME}:${GIT_SHA}" # Y aquí también
  ]
  platforms = [
    "linux/amd64",
    # "linux/arm64" # Descomenta esta línea si quieres builds multi-arquitectura para ARM
  ]
  push = true
}