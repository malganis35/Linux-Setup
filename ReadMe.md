CREATE AN UBUNTU CONTAINER FOR TEST
===================================

```
docker build -t ubuntu:1 .
```

```
docker run -t -i ubuntu:1
```

Get the size of the containers

```
docker container ls -s -a
```

Delete the container 

```
docker rm ubuntu:1
```

Delete all the containers

```
docker container prune
```


PROPER INSTALL OF PYTHON & PYENV FROM ZERO
==========================================

Update the package
```
sudo apt-get update
```

Install basic python packages
```
sudo apt-get install wget curl git-all python3-pip python-is-python3 make build-essential python3-venv
```

Install additional packages to install within pyenv without any bug
```
sudo apt-get install build-essential zlib1g-dev libffi-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev
```

Install pyenv:
```
curl https://pyenv.run | bash
```

Add these lines to your .bashrc 
```
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
```

Source the .bashrc to take effect
```
source ~/.bashrc 
```

Install python 3.9.0 within pyenv 
```
pyenv install 3.9.0
```

Define as global 
```
pyenv global 3.9.0
```

Create a new virtualenv <my_env>
```
pyenv virtualenv 3.9.0 <my_env>
```


