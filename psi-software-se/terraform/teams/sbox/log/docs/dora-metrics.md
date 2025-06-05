## General description
The DevOps Research and Assessment (DORA) team has identified four metrics that measure DevOps performance. Using these metrics helps improve DevOps efficiency and communicate performance to business stakeholders, which can accelerate business results.

DORA includes four key metrics, divided into two core areas of DevOps:

- `Deployment frequency` and `Lead time` for changes measure team velocity.

- `Change failure rate` and `Time to restore` service measure stability.

## DORA metrics in GitLab
We are using GitLab’s built-in feature to measure DORA metrics. These metrics can be found in a project under `Analyze` -> `CI/CD analytics`.

### Deployment Frequency and Lead Time for Changes

To calculate `Deployment frequency` and `Lead time for changes`, we need to specify the production environment in our GitLab pipeline. Once this is configured, data is automatically gathered from the builds, and these metrics are displayed in the analytics section.

### Change Failure Rate and Time to Restore Service

To calculate `Change failure rate` and `Time to restore servic`e, we need to integrate ArgoCD with our GitLab project to monitor failures in the production environment.

Steps to Integrate ArgoCD with GitLab:

1. Create Alerts Integration in GitLab:
- Navigate to `Settings` -> `Monitor` -> `Alerts` in the GitLab project.

- Generate a token for integration. This token will be used by ArgoCD to send alerts.

2. Configure ArgoCD Triggers:

- Set up triggers in ArgoCD to send alerts when applications or services experience failures or are restored.

- Attach annotations about triggers to application that should be monitored.

Once everything is configured, alerts will be sent automatically from ArgoCD to GitLab, and the metrics will be calculated. By automating these processes, teams can seamlessly monitor and improve their DevOps performance using DORA metrics