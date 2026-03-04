# 🚀 OpenShift GitOps & Kustomize Promotion Demo

This repository demonstrates a **GitOps Promotion Workflow** using OpenShift GitOps (ArgoCD) and Kustomize. It showcases how to manage multiple environments (**Dev**, **Test**, **Prod**) using a single base configuration with environment-specific overlays.

## 🏗 Repository Structure
The project follows the standard Kustomize "Base and Overlays" pattern to maintain a single source of truth while allowing per-environment variations:

```text
.
├── base/                   # Common resources for all environments
│   ├── deployment.yaml     # Standard UBI-Minimal deployment
│   └── kustomization.yaml  # Base kustomization logic
└── overlays/               # Environment-specific overrides
    ├── dev/                # Development (Targeting UBI 9.4)
    ├── test/               # Testing (Targeting UBI 9.3)
    └── prod/               # Production (Targeting UBI 9.2)

🛠 Prerequisites
An OpenShift cluster with the Red Hat OpenShift GitOps Operator installed.

Three target namespaces created: demo-dev, demo-test, and demo-prod.

ArgoCD service account must have admin permissions on these namespaces to deploy resources.

🚀 The Demo Workflow
1. Initial State
Once connected to ArgoCD, you will see three applications. Each pod prints a unique message identifying its environment and the specific image version it is running:

Dev: hello - i am dev, i been served using the image : ...:9.4

Test: hello - i am tst, i been served using the image : ...:9.3

Prod: hello - i am prod, i been served using the image : ...:9.2

2. Updating Dev (New Release)
To simulate a new code release or image update, navigate to overlays/dev/kustomization.yaml and update the newTag and the IMAGE_INFO patch value (e.g., from 9.4 to 9.5).

Commit & Push: ArgoCD will detect the "Out of Sync" state and automatically roll out the new image to the Dev environment only.

3. Promoting to Test/Prod
Once verified in Dev, "promote" the version by copying the newTag and IMAGE_INFO values into the test or prod overlay files.

This ensures that the exact same container image version tested in Dev is what moves into production, fulfilling the core promise of GitOps.


## 🛠 Automation Script

To simplify the demo, use the included `promote.sh` script to update environment tags and log strings simultaneously.

**Usage:**
```bash
./promote.sh [dev|test|prod] [tag]


Example (Promoting Dev to 9.5):

Bash
./promote.sh dev 9.5
git add .
git commit -m "feat: upgrade dev to 9.5"
git push origin main

