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
    python-pip \
    python-dev \
    python2.7-dev \
    python-numpy \
    python-matplotlib \
    hdf5-tools \
    libhdf5-dev \
    hdf5-helpers



#Create Working Directory
WORKDIR /docker_main


#install hisat2
#WORKDIR /docker_main
#RUN wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.1.0-Linux_x86_64.zip && \
#    unzip hisat2-2.1.0-Linux_x86_64.zip
#RUN cp -p hisat2-2.1.0/hisat2 hisat2-2.1.0/hisat2-* /usr/bin

WORKDIR /docker_main
RUN wget https://github.com/samtools/htslib/releases/download/1.3.2/htslib-1.3.2.tar.bz2 && \
    tar --bzip2 -xf htslib-1.3.2.tar.bz2 && \
    cd /docker_main/htslib-1.3.2 && \
    ./configure  --enable-plugins && \
    make && \
    make install && \
    cp /lib/libhts.so* /usr/bin/

WORKDIR /docker_main
RUN wget https://github.com/samtools/samtools/releases/download/1.4/samtools-1.4.tar.bz2 && \
    tar -jxf samtools-1.4.tar.bz2 && \
    cd samtools-1.4 && \
    make && \
    make install && \
    cp samtools /usr/bin/


# Clean up
RUN cd /docker_main/ && \
   rm -rf samtools-1.4 htslib-1.3.2 && \
   apt-get autoremove -y && \
   apt-get autoclean -y  && \
   apt-get clean
   
# needed for MGI data mounts
RUN apt-get update && apt-get install -y libnss-sss && apt-get clean all

# Set default working path
WORKDIR /docker_main
