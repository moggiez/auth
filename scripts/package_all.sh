#! /bin/bash

CODE_DIR=$PWD/code/cognito_triggers
DIST_DIR=$PWD/dist
LAMBDAS=("custom_message" "post_confirmation")
 
for lambda in "${LAMBDAS[@]}"
do
    echo "Building lambda '$lambda'..."
	$PWD/scripts/build_and_package_lambda.sh $CODE_DIR/$lambda $DIST_DIR ${lambda}.zip
    echo ""
done
