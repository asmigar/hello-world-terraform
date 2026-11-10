output "image_id" {
  value = docker_registry_image.hello_world.id
  description = "sha256 of the docker image"
}