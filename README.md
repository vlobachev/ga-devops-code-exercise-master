# ga-devops-code-exercise
 [![Build Status](https://travis-ci.com/vlobachev/ga-devops-code-exercise-master.svg?branch=master)](https://travis-ci.com/vlobachev/ga-devops-code-exercise-master)
#### DevOps coding solution
1. Clone this repo in github to your account
2. Clone to your local developer environment.
3. Change "GITHUB_ACCOUNT" in .env to your.
4. For local use look at "> make help".
5. For automation build, test and deploymet follow next steps:
   1. Crete account in https://travis-ci.com/
   2. Connect your Github account and turn on Travis on this repo.
   3. Set "GITHUB_TOKEN" variable see: "More options > Settings >
      Environment Variable" - (get you token in GitHub).
   4. Look at .travis.yml
      - change recipients, to get e-mail notifications.
   5. Create tag in you repo and PUSH - Travis will automatically pull,
      build, test and deploy app.
   6. Important! BUILDS JUST ON NEW TAG.
