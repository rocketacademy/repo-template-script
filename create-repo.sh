#!/bin/bash

set -e # exit if anything goes wrong

echo "Running..."

if [[ $# -eq 2 ]]; then # test for two arguments
    REPO_NAME=$1
    TEMPLATE_NAME=$2

    echo "Creating a repo named: $REPO_NAME from template: $TEMPLATE_NAME"
    gh repo create rocketacademy/$REPO_NAME --public --template rocketacademy/$TEMPLATE_NAME
    cd $REPO_NAME
    git pull origin main
    npm init -y
    npm i eslint eslint-config-airbnb-base eslint-plugin-import

    if [ $2 = 'basic-node-swe1' ]; then # test for two arguments

      # add module type for import syntax
      sed -i '' -e '$ d' package.json
      echo ',"type":"module"}' >> package.json
      #echo "}" >> package.json

    elif [[ $# -eq 2 && $2 = 'swe101' ]]; then # test for two arguments
      echo "creating swe101 repo"

    fi

    git add .
    git commit -m "add package.json"
    git push origin main

else
    echo "Wrong number of arguments: ./create-repo.sh repo-name template-name"
fi
