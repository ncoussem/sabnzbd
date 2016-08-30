FROM alpine:3.4

MAINTAINER ncoussem

ENV SABNZBD_VERSION=1.1.0RC4
ENV PAR2CMDLINE_VERSION=v0.6.14


RUN apk upgrade --update \ 
 && apk add git gcc g++ make automake autoconf openssl ca-certificates unrar p7zip mercurial musl-dev \
     	python py-pip python-dev openssl-dev libffi-dev ffmpeg-libs ffmpeg \
 && pip install --upgrade --no-cache-dir pip cheetah pyopenssl 

# Par2Cmdline (latest version)
RUN git clone --depth 1 --branch ${PAR2CMDLINE_VERSION} https://github.com/Parchive/par2cmdline.git \
&& cd /par2cmdline \
&& aclocal \
&& automake --add-missing \
&& autoconf \
&& ./configure \
&& make \
&& make install \
&& rm -rf /par2cmdline \
&& cd / 

# Yenc
RUN hg clone https://bitbucket.org/dual75/yenc\
    && cd /yenc \
    && python setup.py build \
    && python setup.py install \
    && rm -rf /yenc \
    && cd / 

# SABNZBD
RUN git clone --depth 1 --branch ${SABNZBD_VERSION} https://github.com/sabnzbd/sabnzbd.git 

# menage
RUN rm -rf /var/cache/apk/ \
    /sabnzbd/.git \
    /tmp/*

RUN apk del git gcc g++ make automake autoconf mercurial python-dev libffi-dev musl-dev 

EXPOSE 8080 9090

VOLUME ["/config", "/data"]

WORKDIR /sabnzbd

CMD su -pc "./SABnzbd.py -b 0 -f /config/ -s 0.0.0.0:8080"

