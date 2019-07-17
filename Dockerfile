# Pull base image
FROM nginx:stable
LABEL maintainer="rui@computer.org"

# Install all dependencies
RUN \
  mkdir -p /usr/share/man/man1 && \
  apt-get update && \
  apt-get install -y build-essential software-properties-common libssl-dev wget git && \
  apt-get install -y libboost-all-dev libmpfr-dev libmpfr-doc libmpfr4 libmpfr4-dbg libgmp3-dev maven && \
  apt-get install -y default-jre default-jdk

# Setting fault program up. 
RUN \
  git clone https://github.com/ruimaranhao/qrs19_tutorial.git && \
  mv qrs19_tutorial/joda-time-2.8.1 .. && \
  rm -rf qrs19_tutorial

# Install DDU 
RUN \ 
  git clone https://github.com/aperez/ddu-maven-plugin.git && \
  cd ddu-maven-plugin && \
  mvn install

# Run GZoltar analysis
RUN \
   cd joda-time-2.8.1 && \
   mvn clean gzoltar:prepare-agent test gzoltar:fl-report

# Run DDU analysis
RUN \
   cd joda-time-2.8.1 && \
   mvn ddu:test

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /joda-time-2.8.1/target/


