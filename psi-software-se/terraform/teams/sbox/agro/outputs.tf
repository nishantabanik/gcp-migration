### registries
output "container-images" {
  value = "${module.registry-container-images.url}"
}