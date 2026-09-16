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
 
 ## CI/CD

GitHub Actions authenticates to AWS via **OIDC federation** — no access
keys stored anywhere. Every PR runs `fmt`, `validate`, TFLint (with the
AWS ruleset), module tests under a mocked provider, a Trivy
configuration scan, and posts the plan as a comment. Merges to `main`
apply behind a required-reviewer environment gate. A scheduled job runs
`plan -refresh-only -detailed-exitcode` on weekdays and opens an issue
on drift. Third-party actions are pinned to commit SHAs.

The IAM trust policy accounts for GitHub's immutable OIDC subject format
(repositories created after July 2026).

## Module structure

- `modules/network` — VPC, subnets, routing, security groups (+ tests)
- `modules/service` — IAM, ECS cluster, task definition, service, ALB
- root — ECR, OIDC provider, module composition

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
- v0.3: migrate to Kubernetes
