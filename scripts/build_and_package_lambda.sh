#! /bin/bash

npm install --prefix $1

echo "Packaging $1 to $2/$3"
cd $1 && npm i && zip -r $2/$3 ./