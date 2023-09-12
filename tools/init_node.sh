#!/bin/bash

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash

exec bash

source ~/.bashrc

nvm install v16.17.1
nvm use v16.17.1

npm install -g @vue/cli
