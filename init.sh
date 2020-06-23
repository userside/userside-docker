#!/bin/sh

cp -n docker-compose.yml-example docker-compose.yml
cp -n Makefile-example Makefile
cp -n installer.json-example installer.json

echo "Init comlete. Please, edit docker-compose.yml file, then run"
echo ""
echo "  make install"
echo ""
