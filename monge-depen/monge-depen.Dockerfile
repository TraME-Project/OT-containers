FROM monge-base:stable

RUN dnf install -y \
    boost-devel \
    swig \
    suitesparse-devel \
    eigen3-devel \
    CGAL-devel \
    CImg-devel  \
    openblas-devel

RUN pip3 install lxml && \
    pip3 install numpy pandas scipy matplotlib Pillow && \
    pip3 install jupyterlab

# libraries needed to build R

RUN dnf install -y \
    xz-devel \
    bzip2-devel \
    libjpeg-turbo \
    pcre-devel \
    java-latest-openjdk-devel \
    perl

# download and install R (but do not link with OpenBLAS)

ENV R_VERSION 3.6.3

RUN cd ~ && \
    curl -O --progress-bar https://cran.r-project.org/src/base/R-3/R-${R_VERSION}.tar.gz && \
    tar zxvf R-${R_VERSION}.tar.gz && \
    cd R-${R_VERSION} && \
    ./configure --with-readline=no --with-x=no --with-cairo && \
    make && \
    make install

# cleanup
RUN cd ~ && \
    rm -rf R-${R_VERSION} && \
    rm -f R-${R_VERSION}.tar.gz && \
    dnf clean all
