output "maven-releases" {
  value = "${module.registry-maven-releases.url}"
}

output "maven-snapshots" {
  value = "${module.registry-maven-snapshots.url}"
}

output "maven-snapshots-group" {
  value = "${module.registry-maven-snapshots-group.url}"
}

output "maven-releases-group" {
  value = "${module.registry-maven-releases-group.url}"
}

output "maven-central-proxy" {
  value = "${module.registry-maven-central-proxy.url}"
}

