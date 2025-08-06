# ga-devops-code-exercise
 [![Build Status](https://travis-ci.com/vlobachev/ga-devops-code-exercise-master.svg?branch=master)](https://travis-ci.com/vlobachev/ga-devops-code-exercise-master)
#### DevOps coding solution
1. Clone this repo in github to your account
2. Clone to your local developer environment.
3. Change "GITHUB_ACCOUNT" in .env to your.
4. set global variable "GITHUB_TOKEN" - get it from your Github account
   - > export GITHUB_TOKEN=token
5. For local use look at "> make help".
   - First run:make docker-init - it will build and push container to
     registry.
   - localhost:3000 you will find Metabase
   - for connecting to DB loock at container name: '> docker ps' by
     default it is "devops_dev_postgres-db"
6. For automation build, test and deploymet follow next steps:
   1. Crete account in https://travis-ci.com/
   2. Connect your Github account and turn on Travis on this repo.
   3. Set "GITHUB_TOKEN" variable see: "More options > Settings >
      Environment Variable" - (get you token in GitHub).
   4. Look at .travis.yml
      - change recipients, to get e-mail notifications.
   5. Create tag in you repo and PUSH - Travis will automatically pull,
      build, test and deploy app.
   6. Important! BUILDS JUST ON NEW TAG.
