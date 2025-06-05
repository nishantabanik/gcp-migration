# How to Contribute

This document outlines the guidelines for contributing to this collection of Terraform modules for Google Cloud.
We welcome your contributions!

There are several ways you can contribute to this project:

* Bug Fixes: Did you encounter a bug in a module? We appreciate your help in fixing it. Please create an issue on GitLab describing the bug in detail and provide steps to reproduce it if possible.
* Improvements: Do you have an idea to improve an existing module's functionality or documentation? Raise an issue outlining the proposed change and its benefits.
* New Modules: Have you built a reusable Terraform module for managing a specific GCP resource? We welcome contributions of new modules that follow the guidelines outlined below.

Before submitting a contribution:

* Check for existing issues: Search for existing issues that describe your proposed change.
* Create a branch: Make your modifications on a new branch.

## Contribution Guidelines

Module Structure:

* Each module should focus on a specific GCP resource or set of related resources.
* Modules should be copied and reused from [Terraform Examples and Modules for Google Cloud](https://github.com/GoogleCloudPlatform/cloud-foundation-fabric/tree/master/modules) (Fabric FAST).
* Each module must use the same Terraform provider for Google Cloud in `version.tf`!
    Atm.:
    ```hcl
    terraform {
      required_version = ">= 1.7.4"
      required_providers {
        google = {
          source  = "hashicorp/google"
          version = ">= 5.43.0"
        }
        google-beta = {
          source  = "hashicorp/google-beta"
          version = ">= 5.43.0"
        }
      }
    }
    ```
* Modules should follow a consistent structure, managing resources and corresponding IAM bindings.
* Consider referencing existing Google Cloud Terraform provider documentation for standard resource configuration.

Testing:

* **Ensure your modifications don't break existing functionality.**

Documentation:
* Update the module's `README.md` file with clear instructions on usage, inputs, outputs, and examples.

Code Style:

* Follow consistent code formatting and indentation to maintain clarity. Terraform offers built-in formatting tools like `terraform fmt`.

Merge Requests:

* Once your changes are complete, submit a merge request to the `stable` branch of this repository.
* Include a clear and concise description of your contribution in the merge request message.
* Address any feedback from reviewers before merging.

## License Agreement

By submitting a pull request, you agree to license your contribution under the same [license](./LICENSE) as this project.