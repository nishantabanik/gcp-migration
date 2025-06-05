### registries

output "container-images" {
  value = "${module.registry-container-images.url}"
}

output "maven-releases" {
  value = "${module.registry-maven-releases.url}"
}

output "maven-thirdparty" {
  value = "${module.registry-maven-third-party.url}"
}

output "maven-snapshots" {
  value = "${module.registry-maven-snapshots.url}"
}

output "maven-group" {
  value = "${module.registry-maven-group.url}"
}

output "maven-group-all" {
  value = "${module.registry-maven-group-all.url}"
}

output "npm" {
  value = "${module.registry-npm.url}"
}

output "npm-npmjs-proxy" {
  value = "${module.registry-npm-npmjs-proxy.url}"
}

output "npm-group" {
  value = "${module.registry-npm-group.url}"
}
