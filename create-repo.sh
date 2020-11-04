#!/bin/bash

set -e # exit if anything goes wrong

echo "Running..."

if [[ $# -eq 2 ]]; then # test for two arguments

    # use variables for the arguments
    REPO_NAME=$1
    TEMPLATE_NAME=$2

    echo "Creating a repo named: $REPO_NAME from template: $TEMPLATE_NAME"

    # run the gh cli command
    gh repo create rocketacademy/$REPO_NAME --public --template rocketacademy/$TEMPLATE_NAME

    # gh creates a new dir
    # cd inside
    cd $REPO_NAME

    # the dir doesnt have the gh files yet. pull them down
    git pull origin main

    # create the new npm files
    npm init -y

    # install the editor dev dependencies
    npm i -D eslint eslint-config-airbnb-base eslint-plugin-import

    # if it's for node, we need type : module for import
    if [ $2 = 'base-node-swe1-template' ]; then # test for two arguments

      # add module type for import syntax
      sed -i '' -e '$ d' package.json
      echo ',"type":"module"}' >> package.json

    # later we can make other mods for other repo types
    elif [[ $# -eq 2 && $2 = 'swe101' ]]; then # test for two arguments
      echo "creating swe101 repo"
    fi

    # add and push the new files

    git add .
    git commit -m "add package.json"
    git push origin main

else
    echo "Wrong number of arguments: ./create-repo.sh repo-name template-name"
fi
