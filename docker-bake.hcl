variable "DOCKER_USERNAME" { default = "flichel" } # Tu nombre de usuario de Docker Hub
variable "REPO_NAME" { default = "mi-pagina-web" } # Nombre de tu repositorio Docker Hub
variable "GITHUB_OWNER" { default = "flichel" } # Tu usuario/organización de GitHub para ghcr.io
variable "GHCR_REPO_NAME" { default = "dockernginx" } # Nombre del repositorio en GHCR

group "default" {
  targets = ["nginx-image"]
}

target "nginx-image" {
  dockerfile = "Dockerfile"
  context    = "."
  tags = [
    "${DOCKER_USERNAME}/${REPO_NAME}:latest",
    "${DOCKER_USERNAME}/${REPO_NAME}:1.0",
    "ghcr.io/${GITHUB_OWNER}/${GHCR_REPO_NAME}:latest",
    "ghcr.io/${GITHUB_OWNER}/${GHCR_REPO_NAME}:1.0"
    # Se eliminan las líneas que usaban ${env.GIT_SHA} o ${GIT_SHA}
  ]
  platforms = ["linux/amd64"]
  push = true
}