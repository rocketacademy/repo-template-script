#!/usr/local/bin/bash

declare -A PACKAGE_LISTS

PACKAGE_LISTS=(
  ["express-basic"]="express"
  ["express-ejs"]="express ejs"
  ["express-pg"]="express ejs pg"
  ["mvc"]="express ejs pg sequelize method-override cookie-parser"
  # TODO: mvc webpack
  ["react"]="express ejs pg sequelize method-override cookie-parser"
  ["react-reload"]="express ejs pg sequelize method-override cookie-parser"
)

DEV_PACKAGE_LISTS=(
  ["express-basic"]="nodemon"
  ["express-ejs"]="nodemon"
  ["express-pg"]="nodemon"
  ["mvc"]="nodemon sequelize-cli faker"
  # TODO: mvc webpack
  ["react"]="nodemon \
             sequelize-cli \
             faker \
             webpack \
             webpack-cli \
             webpack-merge \
             @babel/core \
             @babel/preset-env \
             @babel/preset-react \
             babel-loader \
             css-loader \
             html-webpack-plugin \
             mini-css-extract-plugin \
             sass \
             sass-loader \
             axios \
             webpack-dev-middleware \
             webpack-dev-server \
             react \
             react-dom"


  ["react-reload"]="nodemon \
                    sequelize-cli \
                    faker \
                    webpack \
                    webpack-cli \
                    webpack-merge \
                    @babel/core \
                    @babel/preset-env \
                    @babel/preset-react \
                    babel-loader \
                    css-loader \
                    html-webpack-plugin \
                    mini-css-extract-plugin \
                    sass \
                    sass-loader \
                    axios \
                    @pmmmwh/react-refresh-webpack-plugin \
                    react-refresh \
                    webpack-dev-middleware \
                    webpack-hot-middleware \
                    webpack-dev-server \
                    react \
                    react-dom"
)

set -e # exit if anything goes wrong

echo "Running..."

if [[ $# -ge 2 ]]; then # test for two arguments

    # use variables for the arguments
    REPO_NAME=$1
    TEMPLATE_NAME=$2

    echo "Creating a repo named: $REPO_NAME from template: $TEMPLATE_NAME"

    # run the gh cli command
    gh repo create rocketacademy/$REPO_NAME --public --template rocketacademy/$TEMPLATE_NAME

    # gh creates a new dir
    # cd inside
    cd $REPO_NAME

    # get any files made from the template
    git pull origin main

    # the dir doesnt have the gh files yet. pull them down
    #git pull origin main

    # create the new npm files
    npm init -y

    # install the editor dependencies
    npm i -D eslint eslint-config-airbnb-base eslint-plugin-import

    # if it's for node, we need type : module for import
    if [ "${TEMPLATE_NAME}" = 'base-node-swe1-template' ]; then
      # add module type for import syntax
      sed -i '' -e '$ d' package.json
      echo ',"type":"module"}' >> package.json
    fi

    if [ "${TEMPLATE_NAME}" = 'base-mvc-swe1-template' ] || [ "${TEMPLATE_NAME}" = 'base-node-swe1-template' ] || [ "${TEMPLATE_NAME}" = 'base-react-swe1-template' ]; then

      if [[ $# -eq 3 ]]; then # test for a third arg
        echo "template name:"
        echo TEMPLATE_NAME

        NODE_REPO_TYPE=$3

        deps="npm i ${PACKAGE_LISTS[$NODE_REPO_TYPE]}"
        echo "installing deps"
        echo $deps
        eval "$deps"

        devDeps="npm i -D ${DEV_PACKAGE_LISTS[$NODE_REPO_TYPE]}"
        echo "installing DEV deps"
        echo $devDeps
        eval "$devDeps"

      fi # otherwise its the default

    # later we can make other mods for other repo types
    elif [ "${TEMPLATE_NAME}" = 'swe101' ]; then
      echo "creating swe101 repo"
    fi

    # add and push the new files

    git add .
    git commit -m "add package.json"
    git push origin main

else
    echo "Wrong number of arguments: ./create-repo.sh repo-name template-name"
fi
