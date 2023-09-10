FROM postgres:15


RUN apt update
RUN apt install -y build-essential git postgresql-server-dev-15

WORKDIR /tmp
RUN git clone https://github.com/theory/pg-semver.git
WORKDIR /tmp/pg-semver
RUN make
RUN make install
#RUN make installcheck PGUSER=postgres

