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
WORKDIR /docker_main
RUN wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.1.0-Linux_x86_64.zip && \
    unzip hisat2-2.1.0-Linux_x86_64.zip
RUN cp -p hisat2-2.1.0/hisat2 hisat2-2.1.0/hisat2-* /usr/bin


#install samtools
WORKDIR /docker_main
RUN wget https://github.com/samtools/samtools/releases/download/1.7/samtools-1.7.tar.bz2 && \
    tar -jxf samtools-1.7.tar.bz2 && \
    cd samtools-1.7 && \
    make && \
    make install && \
    cp samtools /usr/bin/

#install stringtie
WORKDIR /docker
RUN wget http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.4d.Linux_x86_64.tar.gz && \
    tar zxf stringtie-1.3.4d.Linux_x86_64.tar.gz && \
    cp ./stringtie-1.3.4d.Linux_x86_64/stringtie /usr/bin/


#install prepDE
WORKDIR /docker
RUN wget http://ccb.jhu.edu/software/stringtie/dl/prepDE.py




#install bxtools
RUN cd /opt && git config --global http.sslVerify false && \
    git clone --recursive https://github.com/walaj/bxtools && \
    cd bxtools && \
    ./configure && \
    make && \
    make install && \
    ln -s /opt/bxtools/bin/bxtools /bin/bxtools

# Clean up
RUN cd / && \
   rm -rf /tmp/* && \
   apt-get autoremove -y && \
   apt-get autoclean -y && \
   rm -rf /var/lib/apt/lists/* && \
   apt-get clean
   
# needed for MGI data mounts
RUN apt-get update && apt-get install -y libnss-sss && apt-get clean all

# Set default working path
WORKDIR /docker
