FROM ubuntu:groovy

ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && \
    apt-get install -y make wget curl texlive texlive-xetex latexmk biber && \
    apt-get clean && \
    mkdir /root/texmf && \
    tlmgr init-usertree && \
    echo "#!/bin/bash" > /usr/bin/updmap
