#!/bin/sh

cp -n docker-compose-example.yml docker-compose.yml
cp -n Makefile-example Makefile

@echo "Init comlete. Please, edit docker-compose.yml file, then run"
@echo ""
@echo "  make install"
@echo ""
