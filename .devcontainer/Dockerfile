FROM remlapmot/r-docker:2024-04-02-rstudio

LABEL org.opencontainers.image.source https://github.com/opensafely/research-template

# we are going to use an apt cache on the host, so disable the default debian
# docker clean up that deletes that cache on every apt install
RUN rm -f /etc/apt/apt.conf.d/docker-clean

# Install python 3.10. This is the version used by the python-docker 
# image, used for analyses using the OpenSAFELY pipeline.
RUN --mount=type=cache,target=/var/cache/apt \
    echo "deb http://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu focal main" > /etc/apt/sources.list.d/deadsnakes-ppa.list &&\
    /usr/lib/apt/apt-helper download-file 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xf23c5a6cf475977595c89f51ba6932366a755776' /etc/apt/trusted.gpg.d/deadsnakes.asc &&\
    apt update &&\
    apt install -y curl python3.10 python3.10-distutils python3.10-venv &&\
    # Pip for Python 3.10 isn't included in deadsnakes, so install separately
    curl https://bootstrap.pypa.io/get-pip.py | python3.10 &&\
    # Set default python, so that the Python virtualenv works as expected
    rm /usr/bin/python3 && ln -s /usr/bin/python3.10 /usr/bin/python3

# Copy the Python virtualenv from OpenSAFELY Python action image
COPY --from=ghcr.io/opensafely-core/python:v2 /opt/venv /opt/venv

# Create a local user and give it sudo (aka root) permissions
RUN usermod -aG sudo rstudio
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Required for installing opensafely cli
ENV PATH="/home/rstudio/.local/bin:${PATH}"

USER rstudio
