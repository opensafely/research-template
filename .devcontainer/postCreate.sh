#download and extract latest ehrql source
wget https://github.com/opensafely-core/ehrql/archive/main.zip -P .devcontainer
unzip -o .devcontainer/main.zip -d .devcontainer/
rm .devcontainer/main.zip

# install python and dependencies, set up virtualenv
sudo apt update
wget https://github.com/opensafely-core/python-docker/raw/refs/heads/main/v2/dependencies.txt -q -O - | sed 's/^#.*//' | sudo xargs apt-get install --yes --no-install-recommends
pip install virtualenv opensafely
python3 -m virtualenv .venv
# copy the docker image virtualenv library to the local virtualenv.
# this could alternatively be done with a bind mount (see below)
rm  -rf .venv/lib
docker container create --name python-v2 ghcr.io/opensafely-core/python:v2
docker cp python-v2:/opt/venv/lib .venv/
docker rm python-v2
## bind mount version - faster and less disk space but we need to consider
## implications for `docker pull`/`opensafely pull`
## and what happens if container is stopped/restarted
# rm  -rf .venv/lib/*
# docker run -it -d --name python-v2 --rm ghcr.io/opensafely-core/python:v2 bash
# mount=$(docker inspect python-v2 -f '{{.GraphDriver.Data.MergedDir}}')
# mount --bind -o ro "$mount/opt/venv/lib" .venv/lib


# install R and dependencies
docker create --name r-v2 ghcr.io/opensafely-core/r:v2
sudo docker cp r-v2:/etc/apt/sources.list.d/cran.list /etc/apt/sources.list.d/cran.list
sudo docker cp r-v2:/etc/apt/trusted.gpg.d/cran_ubuntu_key.asc /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo apt update
wget https://raw.githubusercontent.com/opensafely-core/r-docker/refs/heads/main/v2/dependencies.txt -q -O - | sed 's/^#.*//' | sudo xargs apt-get install --yes --no-install-recommends
sudo docker cp r-v2:/usr/lib/R/etc/Rprofile.site /usr/lib/R/etc/Rprofile.site
# copy image R library to local R library
# this could alternatively be done with a bind mount (see below)
docker create --name r-v2 --rm ghcr.io/opensafely-core/r:v2
sudo docker cp r-v2:/usr/local/lib/R/site-library /usr/local/lib/R/
sudo chown -R vscode:vscode /usr/local/lib/R/site-library/
docker rm r-v2
## bind mount version - faster and less disk space but we need to consider
## implications for `docker pull`/`opensafely pull`
## and what happens if container is stopped/restarted
# docker rm r-v2
# docker run -it -d --name r-v2 --rm ghcr.io/opensafely-core/r:v2 bash
# mount=$(docker inspect r-v2 -f '{{.GraphDriver.Data.MergedDir}}')
# sudo mount --bind -o ro "$mount/usr/local/lib/R/site-library" /usr/local/lib/R/