FROM fedora:31

RUN dnf install -y \
    which \
    file \
    tar \
    gzip \
    unzip \
    make \
    cmake \
    ninja-build \
    git \
    gcc \
    gcc-c++ \
    gfortran \
    gmp-devel \
    libtool \
    libcurl-devel \
    libicu-devel \
    openssl-devel \
    zlib-devel \
    libxml2-devel \
    expat-devel \
    python3-devel \
    python3-pip

# set timezone
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# see: https://stackoverflow.com/questions/2720014/how-to-upgrade-all-python-packages-with-pip
RUN pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U

RUN pip3 install --upgrade wheel boto3 packaging

# RUN ln -s /usr/bin/python3 /usr/bin/python

# cleanup
RUN dnf clean all
