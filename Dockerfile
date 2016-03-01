FROM java:8

MAINTAINER davidrpugh <david.pugh@maths.ox.ac.uk>

ENV DEBIAN_FRONTEND noninteractive

USER root

RUN apt-get update -y && \
    apt-get install -y bzip2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*tmp

# Install Scala
ENV BASE_URL=http://downloads.lightbend.com \
    SCALA_VERSION=2.11.7
ENV DOWNLOAD_URL $BASE_URL/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz

RUN curl -o scala-$SCALA_VERSION.tgz $DOWNLOAD_URL && \
    tar -xf scala-$SCALA_VERSION.tgz && \
    rm scala-$SCALA_VERSION.tgz && \
    echo >> .bashrc && \
    echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> .bashrc

# Install SBT
ENV BASE_URL=http://dl.bintray.com/sbt/native-packages/sbt \
    SBT_VERSION=0.13.8
ENV DOWNLOAD_URL $BASE_URL/$SBT_VERSION/sbt-$SBT_VERSION.tgz

RUN curl -Lo sbt-$SBT_VERSION.tgz $DOWNLOAD_URL && \
    tar -xf sbt-$SBT_VERSION.tgz && \
    rm sbt-$SBT_VERSION.tgz && \
    echo >> .bashrc && \
    echo 'export PATH=~/sbt-$SBT_VERSION/bin:$PATH' >> .bashrc

# Run docker images with a non-root user as a security precaution.
RUN useradd -m -s /bin/bash main

# Install Anaconda Python distribution
USER main
ENV HOME /home/main
WORKDIR $HOME

ENV CAPABILITY_HASH 3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3
ENV BASE_URL https://$CAPABILITY_HASH.ssl.cf1.rackcdn.com
ENV PYTHON_VERSION=3 \
    ANACONDA_VERSION=2.5.0

RUN wget -q $BASE_URL/Anaconda$PYTHON_VERSION-$ANACONDA_VERSION-Linux-x86_64.sh
RUN bash Anaconda$PYTHON_VERSION-$ANACONDA_VERSION-Linux-x86_64.sh -b
ENV PATH $HOME/anaconda/bin:$PATH

# Setup the Jupyter notebook
EXPOSE 8888
ADD start-notebook.sh $HOME
