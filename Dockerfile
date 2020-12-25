# we are re building the base container from the mltooling/ml-workspace-minimal:0.9.1 Dockerfile on GitHub
# to ensure that we know exactly what is in it 

FROM cyversevice/ml-workspace-minimal:0.9.1

USER root

# Install a few dependencies for iCommands, text editing, and monitoring instances
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    gcc \
    gnupg \
    htop \
    less \
    libfuse2 \
    libpq-dev \
    libssl1.0 \
    lsb \
    nano \
    nodejs \
    python-requests \
    software-properties-common \
    vim 

# Install iCommands
RUN wget https://files.renci.org/pub/irods/releases/4.1.10/ubuntu14/irods-icommands-4.1.10-ubuntu14-x86_64.deb && dpkg -i *.deb
   
COPY irods_environment.json /root/.irods/irods_environment.json

# Install Docker

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
RUN apt-get update

RUN apt-get install docker-ce -y

# Install Nextflow
RUN wget -qO- https://get.nextflow.io | bash

# Install conda environment
COPY environment.yml /root/environment.yml
RUN conda update -n base -c defaults conda
RUN conda config --add channels bioconda && \
    conda config --add channels conda-forge && \
    conda env update -n base -f environment.yml && \
    conda clean --all


# ENTRYPOINT is set in mltooling/ml-workspace-minimal:0.9.1 container
