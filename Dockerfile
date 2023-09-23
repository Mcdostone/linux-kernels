FROM postgres:16

RUN apt update
RUN apt install -y build-essential git postgresql-server-dev-16


WORKDIR /tmp
RUN git clone https://github.com/theory/pg-semver.git
WORKDIR /tmp/pg-semver
RUN make
RUN make install