# ------------- ALL THIS REQUIRED FOR PAPERSPACE -------------
FROM python:3.9.10

ENV APP_HOME /
WORKDIR $APP_HOME

# Install base utilities
RUN apt-get update && \
    # apt-get install -y build-essentials  && \
    apt-get install -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

RUN pip install -U pip -qqq

RUN conda install -y -c conda-forge jupyterlab

# ------------- FROM HERE ON IS MY ICEVISISION SETUP -------------
RUN wget https://raw.githubusercontent.com/airctic/icevision/master/icevision_install.sh && bash icevision_install.sh cuda11 master && rm icevision_install.sh

RUN pip install torchtext==0.11.0 --upgrade
RUN pip install opencv-python ipywidgets icevision-dashboards
RUN apt update && apt install -y libsm6 libxext6
RUN apt-get install -y libxrender-dev

CMD make lfs && git lfs pull