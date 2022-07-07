#!/bin/sh

test -f docker-compose.yml && mv -n docker-compose.yml compose.yaml
cp -n compose.yaml-example compose.yaml
cp -n Makefile-example Makefile
cp -n .env-example .env

echo "Init comlete. Please, edit .env file, then run"
echo ""
echo "  sudo make install"
echo ""
