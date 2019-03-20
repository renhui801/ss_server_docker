FROM centos

RUN yum -y groupinstall "Development Tools"

RUN yum -y install wget

WORKDIR /root

RUN wget https://github.com/jedisct1/libsodium/releases/download/1.0.16/libsodium-1.0.16.tar.gz

RUN tar xf libsodium-1.0.16.tar.gz 

WORKDIR libsodium-1.0.16

RUN ./configure && make -j2 

RUN make install

RUN echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf

RUN ldconfig

WORKDIR /root

RUN yum -y install python-setuptools
 
RUN easy_install pip

RUN yum install -y git

RUN git clone -b docker https://github.com/renhui801/ss_server.git

WORKDIR ss_server 

RUN pip install -r requirements.txt 

RUN cp apiconfig.py userapiconfig.py 

RUN cp config.json user-config.json

ENV NODE_ID 1

ENV API_INTERFACE glzjinmod

ENV MYSQL_HOST 127.0.0.1

ENV MYSQL_PORT 3306

ENV MYSQL_USER root

ENV MYSQL_PASS root

ENV MYSQL_DB sspanel

RUN chmod +x env.sh

#CMD /bin/sh /root/ss_server/env.sh

CMD /bin/sh -c  '/root/ss_server/env.sh &&  python /root/ss_server/server.py "daemon off;"'
