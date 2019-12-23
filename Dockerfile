FROM alpine

#RUN wget -o /tmp/ProxKey_Linux.zip https://www.e-mudhra.com/repository/downloads/ProxKey_Linux.zip
RUN wget -O /tmp/ePass2003_Linux.zip https://www.e-mudhra.com/repository/downloads/ePass2003_Linux.zip
RUN wget -O /tmp/emsigner-v2.6.zip https://tutorial.gst.gov.in/installers/dscemSigner/emsigner-v2.6.zip

WORKDIR /tmp

RUN chmod 777 -R /tmp \
    && unzip ePass2003_Linux.zip && rm /tmp/ePass2003_Linux.zip \
    && unzip emsigner-v2.6.zip   && rm /tmp/emsigner-v2.6.zip

RUN chmod 777 -R /tmp \
    && unzip ./ePass2003-Linux/ePass2003-Linux-x64.zip \
    && rm -rf ./ePass2003-Linux

RUN sh /tmp/ePass2003-Linux-x64/x86_64/config/config.sh

RUN apk update
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing firefox-esr
RUN apk add openjdk8-jre icedtea-web-mozilla \
    adwaita-icon-theme ttf-dejavu ffmpeg-libs \
    desktop-file-utils
RUN apk add sudo nss-tools curl openssl

RUN export uid=1000 gid=1000 \
 && echo "firefox:x:${uid}:${gid}:firefox,,,:/home/firefox:/bin/bash" >> /etc/passwd \
 && echo "firefox:x:${uid}:" >> /etc/group \
 && echo "firefox ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && mkdir -p /home/firefox \
 && mkdir -p /usr/lib/mozilla/certificates \
 && chown -R :firefox /usr/lib/mozilla/certificates \
 && chmod -R 777 /usr/lib/mozilla/certificates \
 && chown ${uid}:${gid} -R /home/firefox \
 && rm -rf /var/lib/apt/lists/*

COPY import.sh /home/firefox/

RUN echo "date >>/tmp/gst/stderr.log && date >>/tmp/gst/stdout.log" >> /home/firefox/startup.sh \
    && echo "java -jar /tmp/emSigner/emsigner_WS_OMM.jar 2>>/tmp/gst/stderr.log 1>>/tmp/gst/stdout.log &" >> /home/firefox/startup.sh \
    && echo "sleep 15" >> /home/firefox/startup.sh \
    && echo "openssl s_client -showcerts -connect 127.0.0.1:1585 </dev/null 2>/dev/null|openssl x509 -outform PEM >emsigner.pem" >> /home/firefox/startup.sh \
    && echo "echo changeit >passwd.txt" >> /home/firefox/startup.sh \
    && echo "certutil -N -d /usr/lib/mozilla/certificates -f passwd.txt"  >> /home/firefox/startup.sh \
    && echo "certutil -A -n "emsigner" -t "TCu,Cuw,Tuw" -i emsigner.pem -d /usr/lib/mozilla/certificates -f passwd.txt" >> /home/firefox/startup.sh \
    && echo "firefox &" >>  /home/firefox/startup.sh \
    && echo "sleep 15" >> /home/firefox/startup.sh \
    && echo "source import.sh" >>  /home/firefox/startup.sh \
    && echo "ls -l" >>  /home/firefox/startup.sh \
    && chmod 755 /home/firefox/startup.sh \
    && chown firefox /home/firefox/startup.sh

USER firefox
ENV HOME /home/firefox
ENV DISPLAY :0
WORKDIR /home/firefox

CMD ./startup.sh
