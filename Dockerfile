FROM ubuntu:16.04

RUN apt update && apt install -y git curl build-essential autoconf automake libtool unzip pkg-config python-setuptools

RUN git clone https://github.com/google/protobuf.git && cd protobuf && ./autogen.sh && ./configure && make -j8 && make install && ldconfig

RUN git clone https://github.com/protobuf-c/protobuf-c.git && cd protobuf-c && ./autogen.sh && ./configure && make -j8 && make install && ldconfig

# build python-protobuf
RUN cd protobuf/python && python setup.py build && python setup.py install

RUN git clone https://github.com/nanopb/nanopb.git && cd nanopb/generator/proto && make

# build rust-protobuf
RUN curl https://sh.rustup.rs -o rustup.sh && sh ./rustup.sh -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install protobuf


ADD motd /

ENTRYPOINT /motd
