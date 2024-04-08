FROM remlapmot/r-docker:2024-04-02-rstudio

# we are going to use an apt cache on the host, so disable the default debian
# docker clean up that deletes that cache on every apt install
RUN rm -f /etc/apt/apt.conf.d/docker-clean

RUN --mount=type=cache,target=/var/cache/apt \
    sudo apt update && sudo apt install -y python3 python3-pip