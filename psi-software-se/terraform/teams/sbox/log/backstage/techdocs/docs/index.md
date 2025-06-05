# WMS Server Config Template

## Overview
The **WMS Server Config Template** is a Backstage scaffolder template that automates the creation of a YAML configuration file for a WMS server and pushes it to a GitLab repository via a merge request. It provides customizable parameters for server configuration, such as the server name, server size, SSH enablement, and an initialization script.

## Template Details
- **API Version**: `scaffolder.backstage.io/v1beta3`
- **Kind**: `Template`
- **Owner**: `user:guest`
- **Type**: `service`

## Parameters
The template requires the following parameters:


| Parameter       | Description                                                                 | Values/Options                                     |
|-----------------|-----------------------------------------------------------------------------|---------------------------------------------------|
| **serverName**   | The name of the server (e.g., "wms-server-host-test").                       | Must only contain lowercase letters, numbers, and hyphens, and must not end with a hyphen.           |
| **size**         | The size of the server, corresponding to Google Cloud machine types.         | - **small**: 1 vCPU, 3.75 GB memory (e.g., `e2-micro`) <br> - **medium**: 2 vCPUs, 8 GB memory (e.g., `e2-medium`) <br> - **large**: 4 vCPUs, 16 GB memory (e.g., `e2-standard-4`) |
| **enableSsh**    | Whether SSH should be enabled.                                              | `true` (default) or `false`                      |
| **initScript**   | A bash script to initialize the server (e.g., installing dependencies).      | Default: provided below |
| **repoUrl**      | URL of the GitLab repository where the configuration file will be pushed.   | (e.g., `gitlab.com/your-repo/`)                  |


**Default Initialization Script:**
The Default Initialization Script is a bash script that is automatically executed to set up the server after it is created. The script includes a series of commands that prepare the server environment by setting environment variables and installing necessary software packages.
```bash
#!/bin/bash
export APP_ENV=testing
export DEBUG="false"
sudo apt-get update -y
sudo apt-get install -y nginx curl htop
```

## Steps

### 1. Generate Configuration File
- **ID**: `generate-config`
- **Action**: `fetch:template`
- **Description**: Generates a YAML configuration file based on the provided parameters.

### 2. Rename Files
- **ID**: `renameFiles`
- **Action**: `fs:rename`
- **Description**: Renames configuration files to match the server name.

### 3. Push Changes to GitLab Repository
- **ID**: `pushChanges`
- **Action**: `gitlab:repo:push`
- **Description**: Pushes the generated configuration file to the specified GitLab repository.

### 4. Register Component in Backstage
- **ID**: `registerComponent`
- **Action**: `catalog:register`
- **Description**: Registers the component in Backstage, making it available for further integration.

## Output
After successful execution, the following output is available:

| Output | Description |
|--------|-------------|
| **View in Backstage** | Link to the registered component in Backstage. |

## Usage
1. Navigate to the Backstage scaffolder and select **WMS Server Config Template**.
2. Fill in the required parameters.
3. Click **Run** to generate the configuration file and submit a merge request.
4. The component will be registered in Backstage and can be accessed from there.

This template streamlines the process of configuring WMS servers and ensures consistency across deployments.