FROM alpine:latest

MAINTAINER ncoussem

RUN apk upgrade --update \ 
 && apk add git gcc g++ make automake autoconf openssl ca-certificates unrar p7zip mercurial \
     	python py-pip python-dev openssl-dev libffi-dev ffmpeg-libs ffmpeg \
 && pip install --upgrade --no-cache-dir pip cheetah pyopenssl 

# Par2Cmdline (latest version)
RUN git clone --depth 1 https://github.com/Parchive/par2cmdline.git \
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

# SABNzbD
RUN git clone --depth 1 --branch 1.1.0RC3 https://github.com/sabnzbd/sabnzbd.git 

# menage
RUN rm -rf /var/cache/apk/ \
    /sabnzbd/.git \
    /tmp/*

EXPOSE 8080 9090

VOLUME ["/config", "/data"]

WORKDIR /sabnzbd

CMD su -pc "./SABnzbd.py -b 0 -f /config/ -s 0.0.0.0:8080"

