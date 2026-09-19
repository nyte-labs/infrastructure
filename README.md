# personal-infra

Terraform config for my personal AWS infrastructure — a shared Postgres host
plus app servers for side projects.

## Structure

```
modules/
  app-server/        Reusable module for a single app's EC2 instance +
                     security group + Route 53 record.
  postgres-host/     Single EC2 instance running self-hosted Postgres,
                     shared across multiple apps (separate DB + role per app).
main.tf              Wires modules together for current apps.
variables.tf         Shared input variables.
outputs.tf           Useful outputs (IPs, DNS names).
backend.tf           Remote state config.
terraform.tfvars     Variable values.
```

## Usage

```bash
terraform init
terraform plan
terraform apply
```
