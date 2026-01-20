Terraform templates for the assessment.

How to use:

1. Ensure LocalStack is running: `docker-compose up -d localstack`
2. Set Terraform variables as needed (defaults assume LocalStack)

Example:

terraform init
terraform apply -var 'localstack_endpoint=http://localhost:4566' -auto-approve

Notes:
- These templates are meant as a starting point and include comments for where to tighten IAM in production.
- The ECS task definition references an image `localstack/my-api:latest` — replace with your actual image build/push.
