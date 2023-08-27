# Global variables
SHELL:=/bin/bash
SSH_KEY:=~/.ssh/cao-tri.do@mazars.fr
PROJECT=mzenv
VERSION=3.9.0
VENV=${PROJECT}-${VERSION}
VENV_DIR=$(shell pyenv root)/versions/${VENV}
PYTHON=${VENV_DIR}/bin/python
JUPYTER_ENV_NAME=${VENV}
JUPYTER_PORT=8888

# Source for a good Python Makefile: https://gist.github.com/genyrosk/2a6e893ee72fa2737a6df243f6520a6d

## --------------------------------------------------------------------------------------------------------------------
# General options
## --------------------------------------------------------------------------------------------------------------------

## Make sure you have `pyenv` and `pyenv-virtualenv` installed beforehand
##
## https://github.com/pyenv/pyenv
## https://github.com/pyenv/pyenv-virtualenv
##
## On a Mac: $ brew install pyenv pyenv-virtualenv
##
## Configure your shell with $ eval "$(pyenv virtualenv-init -)"
##

# .ONESHELL:
DEFAULT_GOAL: help
.PHONY: help run clean build venv ipykernel update jupyter

# Colors for echos 
ccend=$(shell tput sgr0)
ccbold=$(shell tput bold)
ccgreen=$(shell tput setaf 2)
ccso=$(shell tput smso)

install_initial:
	sudo apt-get update  # to update the local DB with the available remote ubuntu software
	sudo apt-get install python3-pip python-is-python3 make build-essential python3-venv
	sudo apt-get install unzip zip tree git tig terminator htop

install_pyenv:
	curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
	
	@echo '' >> ~/.bashrc
	@echo 'export PYENV_ROOT="$$HOME/.pyenv"' >> ~/.bashrc
	@echo 'command -v pyenv >/dev/null || export PATH="$$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
	@echo 'eval "$$(pyenv init -)"' >> ~/.bashrc
	@echo 'eval "$$(pyenv virtualenv-init -)"' >> ~/.bashrc
	exec $$SHELL
	echo 'Please execute this command to correct your Linux'
	echo 'export PATH="/usr/bin:$$PATH"'

install_python:
	sudo apt-get update
	sudo apt-get install libbz2-dev
	sudo apt-get install build-essential zlib1g-dev libffi-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev
	pyenv install 3.9.0
	pyenv global 3.9.0

setup_ssh:
	chmod 600 ~/.ssh/*

clean_pyenv:
	sudo rm -r .pyenv 
	grep -v 'PYENV_ROOT="$$HOME/.pyenv"' ~/.bashrc > ~/.bashrc_temp
	grep -v 'command -v pyenv >/dev/null || export PATH="$$PYENV_ROOT/bin:$$PATH"' ~/.bashrc_temp > ~/.bashrc_temp2
	grep -v 'eval "$$(pyenv init -)"' ~/.bashrc_temp2 > ~/.bashrc_temp3
	grep -v 'eval "$$(pyenv virtualenv-init -)"' ~/.bashrc_temp3 > ~/.bashrc_new
	rm ~/.bashrc_temp ~/.bashrc_temp2 ~/.bashrc_temp3
	mv ~/.bashrc_new ~/.bashrc

Linux: ## >> install pyenv for linux
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv
	echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
	echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
	exec "$SHELL"
	. ~/.bash_profile
	echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile

mz_versions:
	pyenv versions

mz_setup:
	@echo "$(ccso)--> Create standard arborescence for MZ Laptop $(ccend)"
	cd; mkdir -p g/{knowledge,infra,2022,2023,mz}
	mkdir dev
	mkdir perso

mz_ressources:
	@echo "$(ccso)--> Download the ressources for Python DataScience and PowerBI $(ccend)"
	# pyenv deactivate
	# pyenv activate mzenv
	-mkdir ressources
	-git clone git@github.com:malganis35/useful-python-ressources-downloader.git ./ressources
	cd ressources; pip install -r requirements.txt
	cd ressources; python main_ressources.py
	
eval_ssh:
	eval `ssh-agent`
	ssh-add ${SSH_KEY}

## --------------------------------------------------------------------------------------------------------------------
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUN = \
	%help; \
	while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-\$\(]+)\s*:.*\#\#(?:@([a-zA-Z\-\)]+))?\s(.*)$$/ }; \
	print "usage: make [target]\n\n"; \
	for (sort keys %help) { \
	print "${WHITE}$$_:${RESET}\n"; \
	for (@{$$help{$$_}}) { \
	$$sep = " " x (32 - length $$_->[0]); \
	print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
	}; \
	print "\n"; }

help: ##@other >> Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)
	@echo ""
	@echo "Note: to activate the environment in your local shell type:"
	@echo "   $$ pyenv activate $(VENV)"

