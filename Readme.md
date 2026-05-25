A production-ready DevOps solution demonstrating automated deployment of a containerized web application to Amazon Elastic Kubernetes Engine (EKS) using Terraform, Docker, and Jenkins.

This project automates the complete lifecycle of deploying a web application to Kubernetes:

- Infrastructure as Code: Terraform provisions a managed GKE cluster with all networking components
- Containerization: Optimized Docker image for the application
- Orchestration: Kubernetes manifests for reliable deployment and scaling
- CI/CD Automation: Jenkins pipeline triggers builds, pushes images, and deploys on every commit to `main`
- Public Access: Application exposed via LoadBalancer Service (or Ingress)

Live Application: [Application URL](http://a9b259a56938c445c8c22c762854bddc-48708030.ap-south-1.elb.amazonaws.com/)

┌──────────────────────────────────────────────────────────────┐
│ GitHub Repository │
│ (Spring Boot Source + Dockerfile + Helm Charts + │
│ Terraform + Jenkins Pipeline) │
└──────────────────────┬───────────────────────────────────────┘
│
▼
┌──────────────────────────────────────────────────────────────┐
│ Jenkins CI/CD Pipeline │
│ ┌──────────┬───────────┬──────────────┬────────────┐ │
│ │ SCM │ Build & │ Build & │ Deploy │ │
│ │ Checkout│ Test │ Push Docker │ via Helm │ │
│ │ │ (Maven) │ to ECR │ to EKS │ │
│ └──────────┴───────────┴──────────────┴────────────┘ │
└──────────────────────┬───────────────────────────────────────┘
│
▼
┌──────────────────────────────────────────────────────────────┐
│ Amazon Web Services (AWS) │
│ ┌────────────────────────────────────────────────────────┐ │
│ │ Amazon Elastic Kubernetes Service (EKS) │ │
│ │ (Provisioned via Terraform) │ │
│ │ │ │
│ │ ┌──────────────────────────────────────────────────┐ │ │
│ │ │ VPC (Custom Networking) │ │ │
│ │ │ ┌──────────────────────────────────────────┐ │ │ │
│ │ │ │ EKS Control Plane (AWS Managed) │ │ │ │
│ │ │ └──────────────────────────────────────────┘ │ │ │
│ │ │ ┌──────────────────────────────────────────┐ │ │ │
│ │ │ │ Worker Nodes (EC2 instances) │ │ │ │
│ │ │ │ ┌──────────────────────────────────┐ │ │ │ │
│ │ │ │ │ Deployment (Spring Boot App) │ │ │ │ │
│ │ │ │ │ ├── Pod 1 (via HPA) │ │ │ │ │
│ │ │ │ │ ├── Pod 2 (via HPA) │ │ │ │ │
│ │ │ │ │ └── Pod N (Auto-scaling) │ │ │ │ │
│ │ │ │ └──────────────────────────────────┘ │ │ │ │
│ │ │ │ ┌──────────────────────────────────┐ │ │ │ │
│ │ │ │ │ Service (ClusterIP) │ │ │ │ │
│ │ │ │ └──────────────────────────────────┘ │ │ │ │
│ │ │ │ ┌──────────────────────────────────┐ │ │ │ │
│ │ │ │ │ Ingress (Public HTTP/HTTPS) │ │ │ │ │
│ │ │ │ └──────────────────────────────────┘ │ │ │ │
│ │ │ └──────────────────────────────────────────┘ │ │ │
│ │ └──────────────────────────────────────────────────┘ │ │
│ │ │ │
│ │ ┌──────────────────┐ ┌────────────────────────┐ │ │
│ │ │ ECR │ │ S3 (TF State, │ │ │
│ │ │ (Docker Images) │ │ Artifacts) │ │ │
│ │ └──────────────────┘ └────────────────────────┘ │ │
│ │ │ │
│ └────────────────────────────────────────────────────────┘ │
│ │
│ ┌──────────────────────────────────────────────────────┐ │
│ │ IAM Roles & Policies (RBAC + K8s ServiceAccount) │ │
│ └──────────────────────────────────────────────────────┘ │
│ │
└──────────────────────────────────────────────────────────────┘

```

---

 📁 Project Structure

```

project-HRGF/
│
├── Readme.md # This file
├── .gitignore
│
├── source-code/ # Spring Boot Application
│ ├── Dockerfile # Multi-stage Docker build
│ ├── Jenkinsfile # Jenkins CI/CD Pipeline
│ ├── pom.xml # Maven dependencies
│ ├── mvnw / mvnw.cmd # Maven wrapper
│ │
│ ├── src/
│ │ ├── main/
│ │ │ ├── java/com/example/demo/
│ │ │ │ ├── DemoApplication.java # Spring Boot main class
│ │ │ │ └── HelloController.java # REST controller
│ │ │ │
│ │ │ └── resources/
│ │ │ ├── application.properties # App config
│ │ │ ├── static/ # Static files (CSS, JS)
│ │ │ └── templates/ # Thymeleaf templates
│ │ │
│ │ └── test/
│ │ └── java/.../DemoApplicationTests.java
│ │
│ ├── .mvn/wrapper/ # Maven configuration
│ └── target/ # Build artifacts (gitignored)
│
├── helm/ # Helm Charts (Package Manager for K8s)
│ └── springboot-app/
│ ├── Chart.yaml # Helm chart metadata
│ ├── values.yaml # Default configuration values
│ │
│ └── templates/
│ ├── deployment.yaml # K8s Deployment (templated)
│ ├── service.yaml # K8s Service (ClusterIP)
│ ├── ingress.yaml # K8s Ingress (external access)
│ ├── hpa.yaml # Horizontal Pod Autoscaler
│ ├── serviceaccount.yaml # RBAC ServiceAccount
│ ├── \_helpers.tpl # Helm template helpers
│ └── configmap.yaml # ConfigMaps (if needed)
│
└── terraform/ # Infrastructure as Code (AWS)
├── main.tf # Primary Terraform configuration
├── provider.tf # AWS provider setup
├── variable.tf # Variable definitions
├── terraform.tfvars # Production variables
├── terraform.tfstate # State file (track infra changes)
├── .terraform.lock.hcl # Dependency lock file
│
├── dev/ # Development Environment
│ ├── dev.tfvars # Dev-specific variables
│ └── dev.tfbackend # Dev S3 backend config
│
├── stage/ # Staging Environment
│ ├── stage.tfvars # Stage-specific variables
│ └── stage.tfbackend # Stage S3 backend config
│
├── prod/ # Production Environment
│ ├── prod.tfvars # Prod-specific variables
│ └── prod.tfbackend # Prod S3 backend config
│
├── .terraform/ # Terraform cache (gitignored)
│ ├── modules/
│ └── providers/
│
└── modules/ # Reusable Terraform Modules
├── vpc/ # Virtual Private Cloud
│ ├── main.tf
│ ├── output.tf
│ └── variable.tf
│
├── eks/ # Elastic Kubernetes Service
│ ├── main.tf
│ ├── output.tf
│ └── variable.tf
│
├── iam/ # Identity & Access Management
│ ├── main.tf
│ ├── data.tf
│ ├── output.tf
│ └── variable.tf
│
├── ec2/ # Elastic Compute Cloud (Worker Nodes)
│ ├── main.tf
│ └── variable.tf
│
└── s3/ # S3 Bucket (Terraform state storage)
├── main.tf
├── output.tf
└── variable.tf

# Step 1: AWS Credentials Setup

```bash
# Configure AWS CLI
aws configure

# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter default region (e.g., us-east-1)
# Enter default output format (json)

# Verify configuration
aws sts get-caller-identity
```

# Step 2: Deploy Infrastructure (Terraform)

```bash
cd terraform

# Choose environment: dev, stage, or prod
# Example: Using dev environment

# Initialize Terraform (downloads AWS provider & modules)
terraform init -backend-config=dev/dev.tfbackend

# Review infrastructure plan
terraform plan -var-file=dev/dev.tfvars

# Deploy infrastructure to AWS (takes ~10-15 minutes)
terraform apply -var-file=dev/dev.tfvars
# Confirm by typing 'yes'

# Save outputs (cluster name, endpoints, etc.)
terraform output
```

Outputs will include:

- EKS cluster name
- Cluster endpoint
- ECR repository URL
- VPC ID
- IAM role ARNs

# Step 3: Configure kubectl

```bash
# Get cluster credentials from AWS
aws eks update-kubeconfig \
  --region us-east-1 \
  --name your-cluster-name

# Verify connectivity
kubectl cluster-info
kubectl get nodes
```

# Step 4: Deploy Spring Boot App with Helm

```bash
# Add Helm repository (if using external charts)
# helm repo add myrepo https://charts.example.com
# helm repo update

# Deploy using local Helm chart
helm install springboot-app ./helm/springboot-app \
  --namespace default \
  --values ./helm/springboot-app/values.yaml

# Verify deployment
helm list
kubectl get pods
kubectl get svc

# Check Helm release status
helm status springboot-app
```

# Step 5: Access Application

```bash
# Get Ingress URL (takes ~2-3 minutes to provision AWS ALB)
kubectl get ingress -w

# Wait for EXTERNAL-IP to be assigned, then access:
# http://YOUR_INGRESS_URL

# Or port-forward for testing:
kubectl port-forward svc/springboot-app 8080:8080
# Access at http://localhost:8080
```

# Step 6: Configure Jenkins Pipeline (Optional)

```bash
# Jenkinsfile is in source-code/ directory
# 1. Create new Jenkins job (Pipeline type)
# 2. Point to your GitHub repository
# 3. Set pipeline script path: source-code/Jenkinsfile
# 4. Add Jenkins credentials for:
#    - AWS (for ECR push)
#    - Docker registry access
#    - kubectl kubeconfig
# 5. Trigger build on push to main branch
```

---

🔧 CI/CD Pipeline (Jenkins)

# Jenkinsfile Overview

Located at: `source-code/Jenkinsfile`

The Jenkins pipeline automates the complete deployment lifecycle:

Pipeline Stages:

1. Checkout: Clone source code from Git repository
2. Build:
   - Compile Spring Boot application using Maven (`mvn clean package`)
   - Run unit tests
   - Generate JAR artifact
3. Docker Build:
   - Build Docker image from Dockerfile (multi-stage optimization)
   - Tag with build number and 'latest'
4. Push to ECR:
   - Authenticate with AWS ECR
   - Push Docker image to Amazon Elastic Container Registry
5. Deploy to EKS:
   - Update Helm chart with new image tag
   - Execute `helm upgrade --install` to deploy/update release
   - Wait for pod readiness using `kubectl rollout status`
6. Verify Deployment:
   - Run health check against deployed application
   - Verify pod status and service endpoints
7. Post Actions:
   - Send Slack/email notifications (success/failure)
   - Archive build artifacts and logs

# Jenkins Setup Instructions

1.  Install Required Plugins

In Manage Jenkins → Manage Plugins, install:

- Pipeline
- Docker Pipeline
- AWS Credentials
- Kubernetes CLI
- Helm
- Git
- Maven Integration
- GitHub Integration (for webhooks)

2.  Add Jenkins Credentials

Go to Manage Jenkins → Manage Credentials → System:

AWS Credentials:

```
Type: AWS Credentials
ID: aws-credentials
Access Key ID: [Your AWS Access Key]
Secret Access Key: [Your AWS Secret Key]
Region: us-east-1
```

kubeconfig (for kubectl/Helm access):

```
Type: Secret file
ID: kubeconfig
File: [Download from AWS: aws eks update-kubeconfig]
```

3.  Create Jenkins Pipeline Job

Steps:

1. New Item → Pipeline
2. Job Name: `springboot-app-deploy`
3. Pipeline Configuration:
   - Definition: `Pipeline script from SCM`
   - SCM: `Git`
   - Repository URL: `https://github.com/your-username/project-HRGF.git`
   - Branch: `*/main`
   - Script Path: `source-code/Jenkinsfile`
4. Build Triggers:
   - Enable: `GitHub hook trigger for GITScm polling` (requires webhook)
   - Or: `Poll SCM` → `H/5 * * * *` (check every 5 min)
5. Save

6. Configure GitHub Webhook (Automatic Triggers)

In your GitHub repository:

```
Settings → Webhooks → Add webhook
- Payload URL: http://your-jenkins-url/github-webhook/
- Content type: application/json
- Events: Push events
- Active: ✓
```

# Jenkinsfile Key Variables

Update these in `source-code/Jenkinsfile` before first build:

```groovy
// AWS Configuration
def AWS_ACCOUNT_ID = 'YOUR_AWS_ACCOUNT_ID'
def AWS_REGION = 'us-east-1'
def ECR_REPO_NAME = 'springboot-app'

// EKS Configuration
def EKS_CLUSTER_NAME = 'your-eks-cluster-name'
def EKS_NAMESPACE = 'default'

// Helm Configuration
def HELM_RELEASE_NAME = 'springboot-app'
def HELM_CHART_PATH = './helm/springboot-app'

// Build Configuration
def DOCKER_BUILD_TAG = "${BUILD_NUMBER}"
```

# Manual Pipeline Trigger

From Jenkins UI:

1. Open job: `springboot-app-deploy`
2. Click: Build Now
3. Monitor: Console Output tab

From CLI:

```bash
java -jar jenkins-cli.jar -s http://jenkins-url \
  build springboot-app-deploy -w
```

# View Pipeline Logs

In Jenkins:

1. Job → Build #XXX → Console Output (real-time logs)

In Kubernetes:

```bash
# View application logs
kubectl logs -f deployment/springboot-app

# View all pod events
kubectl describe pod POD_NAME

# Watch deployment rollout
kubectl rollout status deployment/springboot-app
```

# Troubleshooting Pipeline Failures

Docker Push Failed:

```bash
# Verify ECR credentials
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin \
  YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

# Check if image exists
aws ecr describe-images --repository-name springboot-app
```

Helm Deploy Failed:

```bash
# Verify kubeconfig in Jenkins
kubectl config view

# Test Helm locally
helm template springboot-app ./helm/springboot-app/

# Check Helm release history
helm history springboot-app
helm get values springboot-app
```

Pod Stuck in Pending:

```bash
# Check resource availability
kubectl describe pod POD_NAME
kubectl top nodes
kubectl top pod

# Check image pull status
kubectl describe pod -o json | jq '.status.containerStatuses'
```

---

📊 Design Choices

# Infrastructure (Terraform with Modular Architecture)

Why Modular Terraform?

- Reusability: Each module (VPC, EKS, IAM, EC2, S3) can be reused across projects
- Scalability: Easily deploy to dev, stage, and prod without code duplication
- Maintainability: Changes to a module update all deployments using it
- Team Collaboration: Teams can work on different modules independently

Module Breakdown:

- VPC Module: Custom VPC with public/private subnets, NAT gateways for secure outbound traffic
- EKS Module: Managed Kubernetes control plane, worker node groups, auto-scaling enabled
- IAM Module: Least-privilege roles for EKS nodes, Jenkins, and service accounts
- EC2 Module: Auto Scaling Groups for worker nodes with proper security groups
- S3 Module: Backend state storage with encryption and versioning (Terraform state lock)

Environment Strategy:

- dev/: Development environment with minimal resources, faster iteration
- stage/: Production-like environment for pre-release testing
- prod/: Production cluster with high availability, backup, monitoring

# Containerization (Docker)

- Multi-stage Build: Compile Spring Boot in Maven container, copy JAR to minimal base image
- Optimized Base Image: Alpine or distroless reduces image size from 500MB+ to <150MB
- Non-root User: Container runs as unprivileged user for security
- Health Checks: Readiness probe (HTTP /health), liveness probe (restart unhealthy pods)
- .dockerignore: Excludes build artifacts, git files, and unnecessary dependencies

# Kubernetes Orchestration with Helm

Why Helm?

- Templating: Single chart with values.yaml creates dev/stage/prod deployments
- Dependency Management: Easy to package and version entire applications
- Rollback: Helm release history allows quick rollback to previous versions
- Package Management: Share and version applications like package managers (npm, pip)

Helm Components:

- Chart.yaml: Metadata (name, version, description)
- values.yaml: Default configuration (replicas, image, resources, ingress)
- deployment.yaml: K8s Deployment template with `.Values` substitutions
- service.yaml: ClusterIP Service for internal DNS (no LoadBalancer overhead)
- ingress.yaml: AWS ALB Ingress controller for public access with SSL/TLS
- hpa.yaml: Horizontal Pod Autoscaler (scales 1-10 replicas based on CPU/memory)
- serviceaccount.yaml: RBAC ServiceAccount with minimal pod permissions

Deployment Strategy:

```bash
# Dev deployment
helm install springboot-app ./helm/springboot-app -f dev-values.yaml
# Stage deployment
helm install springboot-app ./helm/springboot-app -f stage-values.yaml
# Prod deployment with rollout progress
helm upgrade --install springboot-app ./helm/springboot-app -f prod-values.yaml --wait
```

# CI/CD Pipeline (Jenkins)

Why Jenkins?

- On-Premise: No external service dependency, full control
- Powerful: Groovy DSL supports complex workflows
- Integrations: Native AWS, Docker, Kubernetes, Helm plugin support
- Auditing: Complete build history, logs, artifact storage

Pipeline Stages:

1. Checkout: Git clone with SSH or HTTPS credentials
2. Build: Maven `clean package` with unit tests
3. Docker Build: Buildx for efficient layer caching
4. ECR Push: AWS authentication via Jenkins IAM role
5. Helm Deploy: Dynamic image tag injection into values
6. Verify: kubectl rollout status + health checks
7. Notify: Slack/email on success/failure

Rollback Strategy:

```bash
# Quick rollback if issues detected
helm rollback springboot-app 1
```

---

🏆 Enterprise Best Practices Demonstrated

✅ Infrastructure as Code: Everything version-controlled, auditable, reproducible  
✅ Multi-Environment: dev/stage/prod with different resource allocations  
✅ Helm Templating: Eliminate duplicate YAML, single source of truth  
✅ RBAC: ServiceAccount with minimal permissions per pod  
✅ Auto-Scaling: HPA for cost optimization, CPA for node scaling  
✅ Health Checks: Readiness & liveness probes prevent cascading failures  
✅ Ingress Controller: External access via AWS ALB, better than LoadBalancer service  
✅ Image Optimization: Multi-stage Docker reduces security surface area  
✅ Secrets Management: Sensitive data in K8s Secrets, not hardcoded  
✅ CI/CD Automation: Jenkins eliminates manual deployments, ensures consistency

---

🔒 Security Features

✅ Implemented

- Terraform State Encryption: S3 backend with server-side encryption (AES-256)
- IAM Roles: Least-privilege roles for EKS nodes, Jenkins, and service accounts
- Kubernetes RBAC: ServiceAccount with minimal permissions per pod
- ECR Image Scanning: AWS ECR vulnerability scanning on image push
- Network Security: Private subnets for worker nodes, NAT gateway for outbound traffic
- Secrets Management: Kubernetes Secrets for sensitive data (no hardcoded credentials)
- Pod Security Standards: Security contexts enforce non-root users, read-only filesystems
- VPC Isolation: Custom VPC with security groups restricting ingress/egress

Optional Enhancements (Can be added):

- Network Policies: Restrict pod-to-pod traffic using Calico/Cilium
- Pod Disruption Budgets: Prevent simultaneous pod termination during updates
- AWS WAF: Web Application Firewall on ALB Ingress
- HashiCorp Vault: External secrets management for rotation
- Container Image Signing: Cosign for image provenance
- Audit Logging: CloudTrail + EKS API audit logs for compliance

---

📈 Monitoring & Logging

# Application Logs

```bash
# Stream pod logs in real-time
kubectl logs -f deployment/springboot-app

# View logs from previous pod crash
kubectl logs deployment/springboot-app --previous

# View logs from all pods in deployment
kubectl logs -f deployment/springboot-app --all-containers=true

# Query logs with labels
kubectl logs -f deployment/springboot-app -l app=springboot-app
```

# CloudWatch Logs (AWS)

```bash
# View EKS cluster logs in CloudWatch
aws logs describe-log-groups --query 'logGroups[*].logGroupName'

# Stream logs to CloudWatch (requires CloudWatch agent)
aws logs tail /aws/eks/springboot-app --follow
```

# Pod Metrics

```bash
# View CPU and memory usage (requires metrics-server)
kubectl top nodes
kubectl top pods -n default

# Watch deployment status
kubectl rollout status deployment/springboot-app -w

# Get pod events
kubectl describe pod POD_NAME
```

# Bonus: Prometheus & Grafana (Optional)

If implemented:

```bash
# Deploy Prometheus Helm chart
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack

# Port-forward to Grafana
kubectl port-forward svc/prometheus-grafana 3000:80
# Access at http://localhost:3000 (default: admin/prom-operator)

# Metrics available:
# - container_cpu_usage_seconds_total
# - container_memory_usage_bytes
# - springboot_requests_total
# - springboot_request_duration_seconds
```

# Log Aggregation with ELK Stack (Optional)

```bash
# Deploy Elasticsearch, Logstash, Kibana
helm repo add elastic https://helm.elastic.co
helm install elasticsearch elastic/elasticsearch
helm install logstash elastic/logstash
helm install kibana elastic/kibana

# Access Kibana at http://localhost:5601
```

---

🔄 Deployment Verification

# Helm Release Status

```bash
# Check Helm release status
helm status springboot-app

# List all Helm releases
helm list

# View Helm release history
helm history springboot-app

# Get current Helm values
helm get values springboot-app

# Render templated manifests without deploying
helm template springboot-app ./helm/springboot-app/
```

# Kubernetes Resources

```bash
# Check deployment status and replicas
kubectl get deployment springboot-app -o wide

# View all pods and their status
kubectl get pods -l app=springboot-app

# Check pod details and events
kubectl describe pod POD_NAME

# View HPA status and scaling
kubectl get hpa springboot-app

# Check service and ingress
kubectl get svc springboot-app
kubectl get ingress springboot-app
```

# Application Health

```bash
# View application logs
kubectl logs -f deployment/springboot-app

# Access application from within cluster
kubectl port-forward svc/springboot-app 8080:8080
# Then: curl http://localhost:8080

# Check application endpoints
kubectl exec -it POD_NAME -- curl localhost:8080/actuator/health

# View resource usage
kubectl top pods springboot-app
kubectl top nodes
```

# Common Commands

```bash
# Wait for deployment to be ready
kubectl rollout status deployment/springboot-app --timeout=5m

# Restart deployment
kubectl rollout restart deployment/springboot-app

# Check events
kubectl get events --sort-by='.lastTimestamp'
```

---

🗑️ Cleanup

# Remove Helm Release

```bash
# Uninstall Helm release (keeps PVCs by default)
helm uninstall springboot-app

# Uninstall and remove all associated resources
helm uninstall springboot-app --wait

# Verify release is removed
helm list
```

# Destroy AWS Infrastructure (Terraform)

```bash
cd terraform

# Destroy using the same environment config
# Example: dev environment
terraform destroy -var-file=dev/dev.tfvars

# Confirm by typing 'yes' when prompted
```

# Complete Cleanup Checklist

```bash
# 1. Uninstall Helm release
helm uninstall springboot-app

# 2. Delete Kubernetes resources manually (if any)
kubectl delete pvc --all  # Remove persistent volumes if needed

# 3. Destroy Terraform infrastructure
cd terraform
terraform destroy -var-file=prod/prod.tfvars

# 4. Verify EKS cluster is deleted
aws eks list-clusters

# 5. Check for leftover resources (ALB, RDS, etc.)
aws ec2 describe-load-balancers
aws ec2 describe-volumes

# 6. Empty S3 bucket (if using for state)
aws s3 rm s3://your-bucket-name --recursive
aws s3 rb s3://your-bucket-name

# 7. Clean up IAM roles
aws iam list-roles | grep springboot
```

⚠️ Warning: This will delete all AWS resources (EKS cluster, EC2 nodes, VPC, etc.) and you will incur no further charges. Ensure you have backups before destroying production environments.

---

🐛 Troubleshooting

# Pod Stuck in `ImagePullBackOff`

```bash
# Check image exists in ECR
aws ecr describe-images --repository-name springboot-app

# Verify IAM permissions for worker node role
aws iam list-attached-role-policies --role-name eks-node-role

# Check pod events for detailed error
kubectl describe pod POD_NAME

# Verify image URI in deployment
kubectl get deployment springboot-app -o yaml | grep image

# ECR login from node (if using private registry)
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin \
  123456789012.dkr.ecr.us-east-1.amazonaws.com
```

# Pod Stuck in `Pending`

```bash
# Check if nodes have available resources
kubectl describe node NODE_NAME
kubectl top nodes

# Check pod resource requests vs node capacity
kubectl describe pod POD_NAME

# Verify HPA is not at max replicas
kubectl get hpa springboot-app

# Check for resource quotas
kubectl describe resourcequota

# Scale down other deployments if needed
kubectl scale deployment other-app --replicas=0
```

# Helm Deploy Failed

```bash
# Test Helm template rendering
helm template springboot-app ./helm/springboot-app/

# Validate Helm chart syntax
helm lint ./helm/springboot-app/

# Check Helm release history
helm history springboot-app

# View detailed deployment status
helm status springboot-app

# Rollback to previous release
helm rollback springboot-app 1

# Get Helm values used in deployment
helm get values springboot-app
```

# Ingress Not Receiving Traffic

```bash
# Check Ingress status and address
kubectl get ingress springboot-app
kubectl describe ingress springboot-app

# Verify service endpoints
kubectl get endpoints springboot-app

# Check service type
kubectl get svc springboot-app

# Verify backend targets in AWS ALB
aws elbv2 describe-target-groups
aws elbv2 describe-target-health --target-group-arn ARN

# Check security groups allow ingress
aws ec2 describe-security-groups
```

# Terraform Errors

```bash
# Validate Terraform syntax
terraform validate

# Check if state file is locked
terraform force-unlock LOCK_ID

# Refresh state from AWS
terraform refresh

# View resource dependencies
terraform graph

# Target specific resource for debugging
terraform apply -target=module.eks
```

# Jenkins Pipeline Failures

```bash
# Check Jenkins logs
docker logs jenkins  # If running in container

# Verify credentials are set
Jenkins UI → Manage Jenkins → Manage Credentials

# Test Docker push manually
aws ecr get-login-password | docker login --username AWS --password-stdin ECR_URL
docker build -t ECR_URL/springboot-app:test .
docker push ECR_URL/springboot-app:test

# Test Helm commands manually
helm upgrade --install springboot-app ./helm/springboot-app/ --dry-run

# Verify kubeconfig in Jenkins workspace
cat ~/.kube/config
```

# Port 8080 Not Accessible

```bash
# Check if pod is listening on port 8080
kubectl exec -it POD_NAME -- netstat -tuln | grep 8080

# Verify service port mapping
kubectl get svc springboot-app -o yaml

# Check security group allows traffic
aws ec2 describe-security-groups --filters "Name=group-id,Values=sg-xxxxx"

# Port-forward for testing
kubectl port-forward svc/springboot-app 8080:8080
curl http://localhost:8080
```

# CloudWatch Integration Issues

```bash
# Check if CloudWatch agent is running
kubectl get daemonset -A

# View EKS cluster logs
aws logs describe-log-groups | grep -i eks

# Enable logging in EKS cluster
aws eks update-cluster-logging --cluster-name springboot-app \
  --logging '{"clusterLogging":[{"enabled":true,"types":["api","audit"]}]}'
```

# Common Error Messages

| Error                | Cause                         | Solution                                          |
| -------------------- | ----------------------------- | ------------------------------------------------- |
| `ImagePullBackOff`   | Docker image not found in ECR | Verify image exists: `aws ecr describe-images`    |
| `CrashLoopBackOff`   | App crashes on startup        | Check logs: `kubectl logs POD_NAME`               |
| `Pending`            | Insufficient resources        | Scale down other pods or add nodes                |
| `OutOfMemory`        | Pod exceeds memory limit      | Increase `resources.limits.memory` in values.yaml |
| `Connection refused` | Service not listening         | Verify app is running: `kubectl port-forward`     |
| `Access Denied`      | IAM/RBAC issue                | Check role permissions and service account        |

---

📚 Bonus Features Implemented

The following features demonstrate advanced DevOps practices beyond core requirements:

- ✅ Helm Charts: Complete Helm packaging with dynamic templating (deployment, service, ingress, HPA, RBAC)
- ✅ Horizontal Pod Autoscaler (HPA): Automatic scaling based on CPU/memory metrics
- ✅ Secrets Management: Kubernetes Secrets for sensitive data (no hardcoded values)
- ✅ RBAC ServiceAccount: Pod-level access control with minimal permissions
- ✅ Container Image Scanning: AWS ECR vulnerability scanning on image push
- ✅ Multi-Environment Setup: Separate dev/stage/prod with Terraform state isolation
- ✅ Modular Terraform: Reusable modules for VPC, EKS, IAM, EC2, S3
- ✅ Ingress Controller: AWS ALB integration for load balancing
- ✅ Helm Hooks: Pre/post deployment actions (if implemented)
- ✅ Spring Boot Actuator: Built-in health checks (/health, /metrics endpoints)

---

📚 Resources & Documentation

# AWS & Infrastructure

- [Amazon EKS Documentation](https://docs.aws.amazon.com/eks/)
- [AWS Terraform Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [VPC & Networking Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/)
- [IAM Roles for EKS](https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html)
- [AWS ECR Guide](https://docs.aws.amazon.com/ecr/)

# Kubernetes & Helm

- [Kubernetes Official Documentation](https://kubernetes.io/docs/)
- [Helm Documentation](https://helm.sh/docs/)
- [Helm Best Practices](https://helm.sh/docs/chart_best_practices/)
- [Kubernetes Resource Quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/)
- [HPA Documentation](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)

# Container & Build

- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)
- [Spring Boot Docker Guide](https://spring.io/guides/topicals/spring-boot-docker/)
- [Maven Documentation](https://maven.apache.org/what-is-maven.html)

# CI/CD & Automation

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Groovy for Jenkins](https://www.jenkins.io/doc/book/pipeline/pipeline-syntax/#declarative-pipeline)
- [Jenkins Kubernetes Plugin](https://plugins.jenkins.io/kubernetes/)

# DevOps & Security

- [OWASP Kubernetes Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Kubernetes_Security_Cheat_Sheet.html)
- [Container Security Best Practices](https://www.docker.com/blog/container-security-and-best-practices/)
- [AWS Security Best Practices](https://docs.aws.amazon.com/security/best-practices/)
- [Terraform State Management](https://www.terraform.io/language/state)

---

📝 License

This project is licensed under the MIT License. See LICENSE file for details.

---

👨‍💻 Author

Created as a DevOps Take-Home Assignment demonstrating:

✅ Infrastructure as Code: Terraform with modular architecture (VPC, EKS, IAM, EC2, S3)  
✅ Container Orchestration: Kubernetes on AWS EKS with auto-scaling  
✅ Application Packaging: Helm charts for environment-specific deployments  
✅ Containerization: Optimized multi-stage Docker builds for Spring Boot  
✅ CI/CD Automation: Jenkins pipeline with automated build, push, and deploy  
✅ Cloud Platform Expertise: AWS services (EKS, ECR, ALB, IAM, VPC, CloudWatch)  
✅ Security Practices: RBAC, ServiceAccounts, IAM roles, secrets management  
✅ DevOps Best Practices: IaC, monitoring, logging, rollback strategies, multi-env setup
