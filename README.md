# Terraform-Variables-in-AWS-Input-vs-Output-vs-Local-Variables

This is my personal **hands-on exercise** exploring **Terraform variables** using a simple **AWS S3 bucket**. In this session, I practiced all three types of variables – **Input, Local, and Output** – and learned how to implement and test them.

---

## 🎯 Objective

In this hands-on, I wanted to:

* Understand how **Input Variables** let me customize Terraform configuration.
* Use **Local Variables** to compute values dynamically.
* Use **Output Variables** to display important information after deployment.
* Experiment with **variable precedence** in Terraform.

---

## 🗂️ File Structure

```
├── main.tf           # S3 bucket resource
├── variables.tf      # Input variables
├── locals.tf         # Local variables (computed)
├── output.tf         # Output variables
├── provider.tf       # AWS provider configuration
├── terraform.tfvars  # Variable values
└── README.md         # This file
```

---

## ⚙️ Step 1 – Configure AWS Provider

In `provider.tf`:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
}
```

> This allowed me to interact with AWS and create resources in my region.

---

## ⚙️ Step 2 – Define Input Variables

In `variables.tf`:

```hcl
variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
  default     = "staging"
}

variable "bucket_name" {
  description = "Base name for S3 bucket"
  type        = string
  default     = "my-terraform-bucket"
}
```

> Input variables helped me **avoid hardcoding** and make my configuration reusable.

---

## ⚙️ Step 3 – Define Local Variables

In `locals.tf`:

```hcl
locals {
  common_tags = {
    Environment = var.environment
    Project     = "Terraform-Demo"
    Owner       = "DevOps-Team"
  }

  full_bucket_name = "${var.environment}-${var.bucket_name}-${random_string.suffix.result}"
}
```

> Local variables let me **compute values internally**. I used them to generate a dynamic bucket name and consistent tags.

---

## ⚙️ Step 4 – Create S3 Bucket Resource

In `main.tf`:

```hcl
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  number  = true
  special = false
}

resource "aws_s3_bucket" "demo" {
  bucket = local.full_bucket_name
  tags   = local.common_tags
}
```

> I added a **random suffix** to ensure bucket name uniqueness and applied tags using local variables.

---

## ⚙️ Step 5 – Define Output Variables

In `output.tf`:

```hcl
output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.demo.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.demo.arn
}

output "environment" {
  description = "Environment used for deployment"
  value       = var.environment
}

output "tags" {
  description = "Applied tags"
  value       = local.common_tags
}
```

> Outputs allowed me to **see key information** after deployment.

---

## ⚙️ Step 6 – Providing Input Values

I experimented with different ways to provide input variables:

1. **Default values** in `variables.tf`
2. **terraform.tfvars** (auto-loaded):

```hcl
environment = "demo"
bucket_name = "terraform-demo-bucket"
```

3. **Command line override:**

```bash
terraform plan -var="environment=production"
```

4. **Environment variables:**

```bash
export TF_VAR_environment="development"
terraform plan
```

5. **Different tfvars files:**

```bash
terraform plan -var-file="dev.tfvars"
terraform plan -var-file="production.tfvars"
```

> I observed the **variable precedence**: CLI > tfvars file > environment variable > default.

---

## 🏗️ Step 7 – Commands I Used

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply configuration
terraform apply -auto-approve

# View outputs
terraform output

# Clean up resources
terraform destroy -auto-approve
```

> This workflow helped me test variables and see their effect on the S3 bucket.

---

## 🧪 Testing Hands-On

### Example 1 – Different Inputs

```bash
# Using defaults
terraform plan

# Using terraform.tfvars
terraform plan

# Override via CLI
terraform plan -var="environment=test" -var="bucket_name=my-test-bucket"
```

### Example 2 – Viewing Outputs

```bash
terraform apply -auto-approve
terraform output
```

> Sample output:

```
bucket_name = "demo-terraform-demo-bucket-abc123"
bucket_arn  = "arn:aws:s3:::demo-terraform-demo-bucket-abc123"
environment = "demo"
tags = {
  "Environment" = "demo"
  "Project"     = "Terraform-Demo"
  "Owner"       = "DevOps-Team"
}
```

### Example 3 – Variable Precedence

```bash
# Using terraform.tfvars
terraform plan | grep Environment

# Using environment variable
export TF_VAR_environment="env-var"
terraform plan | grep Environment

# Using CLI override (highest precedence)
terraform plan -var="environment=cli-override" | grep Environment

# Clean up
unset TF_VAR_environment
```

---

## 💡 Key Takeaways

* **Input Variables:** Parameterize configuration and avoid hardcoding.
* **Local Variables:** Compute reusable values dynamically.
* **Output Variables:** Share key information after deployment.
* **Variable Precedence:** Command line > tfvars > environment variables > default values.
* Hands-on practice made me **confident in using Terraform variables** effectively.


