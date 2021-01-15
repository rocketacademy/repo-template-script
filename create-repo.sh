#!/usr/local/bin/bash

# configure git to use main as default branch
git config --global init.defaultBranch main

# declare PACKAGE_LISTS and DEV_PACKAGE_LISTS as associative arrays
declare -A PACKAGE_LISTS
declare -A DEV_PACKAGE_LISTS

PACKAGE_LISTS=(
  ["express-basic"]=" \
    express \
  "
  ["express-ejs"]=" \
    ejs \
    express \
  "
  ["express-pg"]=" \
    ejs \
    express \
    pg \
  "
  ["mvc"]=" \
    cookie-parser \
    ejs \
    express \
    method-override \
    pg \
    sequelize \
  "
  # TODO: mvc webpack
  ["react"]=" \
    cookie-parser \
    ejs \
    express \
    method-override \
    pg \
    sequelize \
  "
  ["react-reload"]=" \
    cookie-parser \
    ejs \
    express \
    method-override \
    pg \
    sequelize \
  "
)

DEV_PACKAGE_LISTS=(
  ["express-basic"]=" \
    nodemon \
  "
  ["express-ejs"]=" \
    nodemon \
  "
  ["express-pg"]=" \
    nodemon \
  "
  ["mvc"]=" \
    faker \
    nodemon \
    sequelize-cli \
  "
  # TODO: mvc webpack
  ["react"]=" \
    @babel/core \
    @babel/preset-env \
    @babel/preset-react \
    axios \
    babel-loader \
    css-loader \
    eslint-config-airbnb \
    eslint-plugin-jsx-a11y \
    eslint-plugin-react \
    eslint-plugin-react-hooks \
    faker \
    html-webpack-plugin \
    mini-css-extract-plugin \
    nodemon \
    react \
    react-dom \
    sass \
    sass-loader \
    sequelize-cli \
    webpack \
    webpack-cli \
    webpack-dev-middleware \
    webpack-dev-server \
    webpack-merge \
  "
  ["react-reload"]=" \
    @babel/core \
    @babel/preset-env \
    @babel/preset-react \
    @pmmmwh/react-refresh-webpack-plugin \
    axios \
    babel-loader \
    css-loader \
    eslint-config-airbnb \
    eslint-plugin-jsx-a11y \
    eslint-plugin-react \
    eslint-plugin-react-hooks \
    faker \
    html-webpack-plugin \
    mini-css-extract-plugin \
    nodemon \
    react \
    react-dom \
    react-refresh \
    sass \
    sass-loader \
    sequelize-cli \
    webpack \
    webpack-cli \
    webpack-dev-middleware \
    webpack-dev-server \
    webpack-hot-middleware \
    webpack-merge \
  "
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
  # gh creates a new dir. cd inside
  cd $REPO_NAME
  # set git pull config to remove warning when pulling
  git config pull.rebase false
  # get any files made from the template
  git pull origin main
  # create the new npm files
  npm init -y
  # install the editor dependencies
  npm i -D eslint eslint-config-airbnb-base eslint-plugin-import

  # if it's for node, we need "type": "module" for import
  if [ "${TEMPLATE_NAME}" = 'base-node-swe1-template' ]; then
    # add module type for import syntax
    sed -i '' -e '$ d' package.json
    echo ',"type": "module"}' >> package.json
  fi

  # install repo-type-specific dependencies
  if [ "${TEMPLATE_NAME}" = 'base-mvc-swe1-template' ] || [ "${TEMPLATE_NAME}" = 'base-node-swe1-template' ] || [ "${TEMPLATE_NAME}" = 'base-react-swe1-template' ]; then

    if [[ $# -eq 3 ]]; then # test for a third arg
      echo "template name:"
      echo $TEMPLATE_NAME

      NODE_REPO_TYPE=$3
      echo "node repo type:"
      echo $NODE_REPO_TYPE

      echo "packages:"
      echo ${PACKAGE_LISTS[$NODE_REPO_TYPE]}

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
  git commit -m "add package.json and package-lock.json"
  git push origin main

else
  echo "Wrong number of arguments: ./create-repo.sh repo-name template-name"
fi
