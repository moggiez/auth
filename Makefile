infra-init:
	terraform init -force-copy -backend-config="bucket=moggies.io-terraform-state-backend" -backend-config="dynamodb_table=moggies.io-auth-terraform_state" -backend-config="key=auth-terraform.state" -backend-config="region=eu-west-1"

infra-debug:
	TF_LOG=DEBUG terraform apply -auto-approve infra

deploy:
	terraform init && terraform apply -auto-approve

preview:
	terraform init && terraform plan

fmt:
	terraform fmt -recursive

undeploy:
	terraform destroy