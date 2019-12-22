FROM alpine

RUN \
    apk add \
    desktop-file-utils \
    adwaita-icon-theme \
    ttf-dejavu \
    ffmpeg-libs \
    # The following package is used to send key presses to the X process.
    xdotool

RUN apk update \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing firefox \
    && apk add openjdk8-jre

RUN apk add icedtea-web-mozilla

RUN export uid=1000 gid=1000 \
 && mkdir -p /home/firefox \
 && echo "firefox:x:${uid}:${gid}:firefox,,,:/home/firefox:/bin/bash" >> /etc/passwd \
 && echo "firefox:x:${uid}:" >> /etc/group \
 && echo "firefox ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && chown ${uid}:${gid} -R /home/firefox \
 && rm -rf /var/lib/apt/lists/*

#RUN locale-gen $LANG

#RUN wget -o /tmp/ProxKey_Linux.zip https://www.e-mudhra.com/repository/downloads/ProxKey_Linux.zip
RUN wget -O /tmp/ePass2003_Linux.zip https://www.e-mudhra.com/repository/downloads/ePass2003_Linux.zip
RUN wget -O /tmp/emsigner-v2.6.zip https://tutorial.gst.gov.in/installers/dscemSigner/emsigner-v2.6.zip

WORKDIR /tmp

RUN chmod 777 -R /tmp \
    && unzip ePass2003_Linux.zip \
    && unzip emsigner-v2.6.zip \
    && rm /tmp/ePass2003_Linux.zip /tmp/emsigner-v2.6.zip

RUN chmod 777 -R /tmp \
    && rm ./ePass2003-Linux/ePass2003-Linux-i386.zip \
    && unzip ./ePass2003-Linux/ePass2003-Linux-x64.zip \
    && rm -rf ./ePass2003-Linux

RUN sh /tmp/ePass2003-Linux-x64/x86_64/config/config.sh

WORKDIR /tmp/ePass2003-Linux-x64/x86_64/redist/NSS_Firefox_register

#RUN chmod 755 nssFirefox && sh register_Firefox.sh A libcastle_v2.so.1.0.0
#
USER firefox
ENV HOME /home/firefox
ENV DISPLAY :0
ENV LANG en_IN
ENV LANGUAGE en_IN:en

#ENTRYPOINT ['firefox']
