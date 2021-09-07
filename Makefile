infra-init:
	terraform init -force-copy -backend-config="bucket=moggies.io-terraform-state-backend" -backend-config="dynamodb_table=moggies.io-auth-terraform_state" -backend-config="key=auth-terraform.state" -backend-config="region=eu-west-1"

infra-debug:
	TF_LOG=DEBUG terraform apply -auto-approve infra

build-cleanup:
	rm -rf ./dist/* & mkdir -p dist

build: build-cleanup
	./scripts/package_all.sh

deploy: build
	terraform init && terraform apply -auto-approve

preview: build
	terraform init && terraform plan

fmt:
	terraform fmt -recursive

undeploy:
	terraform destroy

update-custom_message-lambda: build
	aws lambda update-function-code --function-name cognito_trigger_custom_message --zip-file fileb://$(shell pwd)/dist/custom_message.zip --publish | jq .FunctionArn

update-post_confirmation-lambda: build
	aws lambda update-function-code --function-name cognito_trigger_post_confirmation --zip-file fileb://$(shell pwd)/dist/post_confirmation.zip --publish | jq .FunctionArn

npm-auth:
	aws codeartifact login --tool npm --repository team-npm --domain moggies-io --domain-owner 989665778089