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

# libraries needed to build R (libXt-devel for X11)

RUN dnf install -y \
    xz-devel \
    bzip2-devel \
    libjpeg-turbo-devel \
    libpng-devel \
    cairo-devel \
    pcre-devel \
    java-latest-openjdk-devel \
    perl \
    libX11-devel \
    libXt-devel

# download and install R (but do not link with OpenBLAS)

ENV R_VERSION 3.6.3

RUN cd ~ && \
    curl -O --progress-bar https://cran.r-project.org/src/base/R-3/R-${R_VERSION}.tar.gz && \
    tar zxvf R-${R_VERSION}.tar.gz && \
    cd R-${R_VERSION} && \
    ./configure --with-readline=no --with-x --with-cairo && \
    make && \
    make install

# install IRKernel

RUN dnf install -y czmq-devel

RUN echo -e "options(bitmapType = 'cairo', repos = c(CRAN = 'https://cran.rstudio.com/'))" > ~/.Rprofile
RUN R -e "install.packages(c('repr', 'IRdisplay', 'IRkernel'), type = 'source')"
RUN R -e "IRkernel::installspec(user = FALSE)"

# install Gurobi

ENV GUROBI_VERSION=9.0.1

RUN mkdir -p /home/gurobi/ && \
    cd /home/gurobi/ && \
    wget -P /home/gurobi/ http://packages.gurobi.com/${GUROBI_VERSION::-2}/gurobi${GUROBI_VERSION}_linux64.tar.gz && \
    tar xvfz /home/gurobi/gurobi${GUROBI_VERSION}_linux64.tar.gz && \
    mkdir -p /opt/gurobi && \
    mv /home/gurobi/gurobi901/linux64/ /opt/gurobi && \
    rm -rf /home/gurobi

ENV GUROBI_HOME="/opt/gurobi/linux64"
ENV PATH="${PATH}:${GUROBI_HOME}/bin"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${GUROBI_HOME}/lib"

# install Gurobi R package

RUN R -e "install.packages(c('slam'), type = 'source')"

RUN cd /opt/gurobi/linux64/R && \
    tar xvfz gurobi_9.0-1_R_3.6.1.tar.gz && \
    R -e "install.packages('gurobi', repos = NULL)"

# cleanup

RUN cd ~ && \
    rm -rf R-${R_VERSION} && \
    rm -f R-${R_VERSION}.tar.gz && \
    dnf clean all
