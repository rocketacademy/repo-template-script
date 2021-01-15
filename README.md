# repo-template-script

Create repos from a template using GitHub command line.

# Prerequisites:

#### Mac Only.

#### Install Bash and GitHub command line for script:

Need later version of Bash than MacOS default for associative arrays.

```
brew install bash gh
```

#### Set configs for GitHub's new default branch name:

```
git config --global init.defaultBranch main
```

#### Know which template repo you want to copy from.

# Run the command:

We need to run the script from outside `repo-template-script` because the script creates a new local repo in the folder where the script is executed.

```
$ ./repo-template-script/create-repo.sh new-repo-name template-repo-name
```

# repo types

At the top of the script file is a hash of all the packages that need to be installed for each repo type.

For example the hash says that making an express-pg app installs express, ejs and pg.

```
$ ./repo-template-script/create-repo.sh <SOME_NAME> base-node-swe1-template express-pg
```

If you want to create a new repo type add a key and value to the hash.

### Recipes

basic node cli repo

```
$ ./repo-template-script/create-repo.sh <SOME_NAME> base-node-swe1-template
```

basic CRUD express repo - installs express

```
$ ./repo-template-script/create-repo.sh <SOME_NAME> base-node-swe1-template express-basic
```

CRUD express EJS

```
$ ./repo-template-script/create-repo.sh <SOME_NAME> base-node-swe1-template express-ejs
```

CRUD express PG

```
$ ./repo-template-script/create-repo.sh <SOME_NAME> base-node-swe1-template express-pg
```

basic bootstrap repo (has empty html / css files / link / script)

```
$ ./repo-template-script/create-repo.sh <SOME_NAME> base-bootstrap-swe1-template
```

basic html / css swe101 repo (no files)

```
$ ./repo-template-script/create-repo.sh <SOME_NAME> base-css-html-swe1-template
```

MVC / sequelize

```
$ ./repo-template-script/create-repo.sh <SOME_NAME> base-mvc-swe1-template mvc
```

React MVC

```
$ ./repo-template-script/create-repo.sh <SOME_NAME> base-react-swe1-template react
```

React Reload MVC

```
$ ./repo-template-script/create-repo.sh <SOME_NAME> base-react-swe1-template react-reload
```
