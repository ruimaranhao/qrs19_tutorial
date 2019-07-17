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
  wget https://gist.github.com/ruimaranhao/560d94f445c34d4a4f43647c8bb30ee7/raw/08b8dad78403e7f10f8d1a488e7b1f004eed57b0/joda-time-2.8.1.tgz && \ 
  tar zxvf joda-time-2.8.1.tgz && \ 
  rm joda-time-2.8.1.tgz

# Install DDU 
RUN \ 
  git clone https://github.com/aperez/ddu-maven-plugin.git && \
  cd ddu-maven-plugin && \
  mvn install

# RUN GZoltar analysis
RUN \
   cd joda-time-2.8.1 && \
   mvn clean gzoltar:prepare-agent test gzoltar:fl-report

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /joda-time-2.8.1/target/site/


