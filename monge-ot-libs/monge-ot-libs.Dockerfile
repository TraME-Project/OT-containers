FROM monge-depen:stable

RUN cd ~ && mkdir ot_libs

# PyMongeAmpere 
RUN cd ~/ot_libs && \
    git clone https://github.com/mrgt/MongeAmpere.git && \
    git clone https://github.com/mrgt/PyMongeAmpere.git && \
    cd PyMongeAmpere && git submodule update --init --recursive && \
    mkdir build && cd build && \
    cmake -DCGAL_DIR=/usr/lib64/cmake/CGAL .. && \
    make -j2

# Siconos
RUN cd ~/ot_libs && \
    git clone https://github.com/siconos/siconos.git && \
    cd siconos && \
    mkdir build && cd build && \
    cmake .. && \
    make -j2 && \
    make install

# Siconos examples
RUN cd ~/ot_libs && \
    git clone https://github.com/siconos/siconos-tutorials.git 
