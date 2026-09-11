# platform-stack
 
A containerized HTTP service on AWS ECS Fargate behind an Application
Load Balancer, fully defined in Terraform with S3 remote state and
native locking.
 
## Architecture
 
````
Internet → ALB (2 AZs, :80) → target group (ip, GET /health)
        → ECS Fargate task (awsvpc, 0.25 vCPU / 0.5 GB, image from ECR)
        → CloudWatch Logs (/ecs/platform-stack, 7-day retention)
````
 
## Design decisions
 
- **Public subnets, not private.** Private needs a NAT Gateway
  (~$33/mo) to reach ECR; public + `assign_public_ip` costs ~$3.65/mo.
  Production: private subnets + VPC endpoints.
- **`for_each` over `count`** — stable keys; removing one subnet
  doesn't renumber the rest.
- **SG-to-SG references** — the app accepts traffic from the ALB's
  security group, not a CIDR.
- **Standalone SG rule resources** — one resource per rule, clean
  diffs.
- **S3-native state locking** (`use_lockfile`) — DynamoDB locking is
  deprecated.
- **Deployment circuit breaker** — a deploy that never goes healthy
  rolls back.
- **Immutable ECR tags** — a version tag means exactly one image.
 
## Usage
 
```bash
terraform init && terraform apply
curl "$(terraform output -raw alb_url)/health"
terraform destroy      # ~$0.04/hr while running
```
 
## Cost
ALB ~$16–18/mo · Fargate ~$9/mo · public IPv4 ~$3.65/mo. Destroyed
between sessions.
 
## Next
- v0.2: modules + CI (OIDC, plan-on-PR, Trivy scan)
- v0.3: migrate to Kubernetes
