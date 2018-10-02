FROM ubuntu:latest

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
    hdf5-tools \
    libhdf5-dev \
    hdf5-helpers \
    ncurses-dev \
    openjdk-8-jre-headless \
    python3-pip \
    python-dev \
    vim-tiny \
    libnss-sss
    
    
    
RUN pip3 install --upgrade setuptools && \
    pip3 install numpy && \
    pip3 install matplotlib && \
    pip3 install pandas && \
    pip3 install scipy && \
    pip3 install pysam && \
    pip3 install biopython && \
    pip3 install cutadapt
    
    
#Create Working Directory
WORKDIR /docker_main

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

# install star aligner
ENV star_version 2.5.3a
WORKDIR /docker_main
ADD https://github.com/alexdobin/STAR/archive/${star_version}.tar.gz /usr/bin/
RUN tar -xzf /usr/bin/${star_version}.tar.gz -C /usr/bin/
RUN cp /usr/bin/STAR-${star_version}/bin/Linux_x86_64/* /usr/local/bin

# Clean up
RUN cd /docker_main / && \
   rm -rf hisat2-2.1.0 samtools-1.4 stringtie-1.3.4d.Linux_x86_64 2.5.3a.tar.gz && \
   apt-get autoremove -y && \
   apt-get autoclean -y  && \
   apt-get clean
   
# needed for MGI data mounts
RUN apt-get update && apt-get install -y libnss-sss && apt-get clean all

# Set default working path
WORKDIR /docker_main
