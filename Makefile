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

# .ONESHELL:
DEFAULT_GOAL: help
.PHONY: help run clean build venv ipykernel update jupyter

# Colors for echos 
ccend=$(shell tput sgr0)
ccbold=$(shell tput bold)
ccgreen=$(shell tput setaf 2)
ccso=$(shell tput smso)

## Initial setup to follow
install_initial:
	sudo apt-get update  # to update the local DB with the available remote ubuntu software
	sudo apt-get install python3-pip python-is-python3 make build-essential python3-venv
	sudo apt-get install unzip zip tree git tig terminator htop

## Install pyenv 
install_pyenv:
	sudo apt-get install git
	curl https://pyenv.run | bash


## Install python
install_python:
	sudo apt-get update
	sudo apt-get install build-essential zlib1g-dev libffi-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev
	pyenv install 3.9.0
	pyenv global 3.9.0

## Clean pyenv
clean_pyenv:
	sudo rm -r .pyenv 
	grep -v 'PYENV_ROOT="$$HOME/.pyenv"' ~/.bashrc > ~/.bashrc_temp
	grep -v 'command -v pyenv >/dev/null || export PATH="$$PYENV_ROOT/bin:$$PATH"' ~/.bashrc_temp > ~/.bashrc_temp2
	grep -v 'eval "$$(pyenv init -)"' ~/.bashrc_temp2 > ~/.bashrc_temp3
	grep -v 'eval "$$(pyenv virtualenv-init -)"' ~/.bashrc_temp3 > ~/.bashrc_new
	rm ~/.bashrc_temp ~/.bashrc_temp2 ~/.bashrc_temp3
	mv ~/.bashrc_new ~/.bashrc

## Install tidy viewer for csv files
install_tv:
	wget https://github.com/alexhallam/tv/releases/download/1.4.30/tidy-viewer_1.4.30_amd64.deb
	sudo dpkg -i tidy-viewer_1.4.30_amd64.deb
	echo "alias tv='tidy-viewer'" >> ~/.bashrc
	echo "Finish the install with: source ~/.bashrc"

## Install gitui for git
install_gitui:
	curl -s curl -s https://api.github.com/repos/extrawurst/gitui/releases/latest | grep -wo "https.*linux.*gz" | wget -qi -
	tar xzvf gitui-linux-musl.tar.gz
	rm gitui-linux-musl.tar.gz
	sudo chmod +x gitui
	sudo mv gitui /usr/local/bin
	echo "alias g='gitui'" >> ~/.bashrc

## Install data analyst useful packages
install_da:
	sudo apt-get install ranger trash-cli neofetch ncdu

## Setup ssh permissions
setup_ssh:
	chmod 600 ~/.ssh/*

## Install Linux information
Linux:
	@echo '1. run first "make install_initial" to install standard linux package'
	@echo '2. run "make install_pyenv" to install pyenv'
	@echo '3. run "make install_python" to install python 3.9 inside pyenv (last stable version)'

brew:
	@echo 'brew install pyenv pyenv-virtualenv'

## Check pyenv versions
mz_versions:
	pyenv versions

## Setup knowledge center
mz_setup:
	@echo "$(ccso)--> Create standard arborescence for MZ Laptop $(ccend)"
	cd; mkdir -p g/{knowledge,infra,2022,2023,mz}
	mkdir dev
	mkdir perso

## Setup ressources
mz_ressources:
	@echo "$(ccso)--> Download the ressources for Python DataScience and PowerBI $(ccend)"
	# pyenv deactivate
	# pyenv activate mzenv
	-mkdir ressources
	-git clone git@github.com:malganis35/useful-python-ressources-downloader.git ./ressources
	cd ressources; pip install -r requirements.txt
	cd ressources; python main_ressources.py

## Evaluate ssh agent
eval_ssh:
	eval `ssh-agent`
	ssh-add ${SSH_KEY}

#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
.PHONY: help
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')


