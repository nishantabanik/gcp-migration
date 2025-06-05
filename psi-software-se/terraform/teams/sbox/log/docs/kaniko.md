# Kaniko Integration for Kubernetes Builds

This document describes the use of Kaniko as a tool for building Docker images directly within a Kubernetes environment. Kaniko provides a secure and efficient alternative to traditional Docker-based image builds, particularly in Kubernetes contexts.

## Overview

Kaniko was chosen as the tool of choice for building Docker images due to its seamless integration with Kubernetes. Unlike tools such as Buildah, which are not specifically optimized for Kubernetes and present more complex integrations, Kaniko offers a straightforward approach to building images without requiring a Docker daemon.

### Advantages of Kaniko

- **No Privileged Mode Required**: Kaniko can build images without requiring root or privileged mode, enhancing security compared to Docker, which necessitates root privileges.
- **Caching Support**: Kaniko supports caching of intermediate layers, which can significantly speed up subsequent builds.

This guide is related to DEVOPS-80 and focuses on building Docker images directly in Kubernetes. Note that while this example demonstrates the local build process, integrating Kaniko into a Jenkins pipeline is beyond the scope of this document.

## Assumptions

- A running Kubernetes cluster is available.
- A Dockerfile is present on the node where the Kaniko pod will be executed.

## Kaniko Pod Configuration

The core part of the configuration is the `pod.yaml` file, which specifies the Kaniko image and provides the necessary arguments for the build process.

### Key Components

1. **Dockerfile**: Specifies the path to the Dockerfile to be built.
2. **Context**: Defines the build context for Kaniko, similar to the Docker daemon's build context. This directory should contain the Dockerfile and any files referenced by the Dockerfile (e.g., those used in `COPY` commands).
3. **No-Push Flag**: Use this flag if you only want to build the image without pushing it to a registry.

## Kaniko Documentation

For more detailed information and advanced usage of Kaniko, refer to the [Kaniko documentation](https://github.com/GoogleContainerTools/kaniko?tab=readme-ov-file).

## Reference

This guide is inspired by examples from [Baeldung's Kaniko guide](https://www.baeldung.com/ops/kaniko).

---

This README provides a basic understanding of how to use Kaniko for building Docker images in Kubernetes. Adjustments to the configuration and usage may be necessary based on your specific environment and requirements.
