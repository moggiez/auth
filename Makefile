infra-init:
	terraform init -force-copy -backend-config="bucket=moggies.io-terraform-state-backend" -backend-config="dynamodb_table=moggies.io-auth-terraform_state" -backend-config="key=auth-terraform.state" -backend-config="region=eu-west-1"

infra-debug:
	TF_LOG=DEBUG terraform apply -auto-approve infra


build-cleanup:
	rm -rf ./dist/* & mkdir -p dist

build-custom-message:
	cd code/cognito_triggers/custom_message && zip -r ../../../dist/custom_message.zip ./

build: build-cleanup build-custom-message

deploy: build
	terraform init && terraform apply -auto-approve

preview: build
	terraform init && terraform plan

fmt:
	terraform fmt -recursive

undeploy:
	terraform destroy