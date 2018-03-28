FROM ubuntu:xenial

MAINTAINER sridhar <sridhar@wustl.edu>

LABEL docker_image rna_seq_analysis

#dependencies

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    build-essential \
    bzip2 \
    curl \
    g++ \
    git \
    less \
    libcurl4-openssl-dev \
    libpng-dev \
    libssl-dev \
    libxml2-dev \
    make \
    pkg-config \
    rsync \
    unzip \
    wget \
    zip \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    python \
    hdf5-tools \
    libhdf5-dev \
    hdf5-helpers \
    ncurses-dev
    
#Create Working Directory
WORKDIR /docker_main

#install conda
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

# Install conda
RUN cd docker_main/ && \
    mkdir -p $CONDA_DIR && \
    curl -s https://repo.continuum.io/miniconda/Miniconda3-4.3.21-Linux-x86_64.sh -o miniconda.sh && \
    /bin/bash miniconda.sh -f -b -p $CONDA_DIR && \
    rm miniconda.sh && \
    $CONDA_DIR/bin/conda config --system --add channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    conda clean -tipsy

RUN conda create --quiet --yes -p $CONDA_DIR/envs/python2 python=2.7 'pip' && \
    conda clean -tipsy && \
    #dependencies sometimes get weird - installing each on it's own line seems to help
    pip install numpy==1.13.0 && \
    pip install scipy==0.19.0 && \
    pip install cruzdb==0.5.6 && \
    pip install cython==0.25.2 && \
    pip install pyensembl==1.1.0 && \
    pip install pyfaidx==0.4.9.2 && \
    pip install pybedtools==0.7.10 && \
    pip install cyvcf2==0.7.4 && \
    pip install intervaltree_bio==1.0.1 && \
    pip install pandas==0.20.2 && \
    pip install scipy==0.19.0 && \
    pip install pysam==0.11.2.2 && \
    pip install seaborn==0.7.1 && \
    pip install scikit-learn==0.18.2 && \
    pip install openpyxl==2.4.8


#install hisat2
WORKDIR /docker_main
RUN wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.1.0-Linux_x86_64.zip && \
    unzip hisat2-2.1.0-Linux_x86_64.zip
RUN cp -p hisat2-2.1.0/hisat2 hisat2-2.1.0/hisat2-* /usr/bin


#install samtools
WORKDIR /docker_main
RUN wget https://github.com/samtools/samtools/releases/download/1.4/samtools-1.4.tar.bz2 && \
    tar -jxf samtools-1.4.tar.bz2 && \
    cd samtools-1.4 && \
    make && \
    make install && \
    cp samtools /usr/bin/

#install stringtie
WORKDIR /docker_main
RUN wget http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.4d.Linux_x86_64.tar.gz && \
    tar -zxf stringtie-1.3.4d.Linux_x86_64.tar.gz && \
    cp ./stringtie-1.3.4d.Linux_x86_64/stringtie /usr/bin/


#install prepDE
WORKDIR /docker_main
RUN wget http://ccb.jhu.edu/software/stringtie/dl/prepDE.py

# Clean up
RUN cd /docker_main / && \
   rm -rf hisat2-2.1.0 samtools-1.4 stringtie-1.3.4d.Linux_x86_64  && \
   apt-get autoremove -y && \
   apt-get autoclean -y  && \
   apt-get clean
   
# needed for MGI data mounts
RUN apt-get update && apt-get install -y libnss-sss && apt-get clean all

# Set default working path
WORKDIR /docker_main
