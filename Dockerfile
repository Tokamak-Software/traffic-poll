FROM ubuntu:18.04
WORKDIR root

RUN apt-get update &&\
  apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev git ffmpeg wget zlibc zlib1g zlib1g-dev

# # Add the poller
# ADD poller /etc/poller
# RUN (cd /etc/poller && go build .)
COPY ./bin/traffic-poller traffic-poller

# Clone nginx rtmp module
RUN git clone https://github.com/sergey-dryabzhinsky/nginx-rtmp-module.git nginx-rtmp

RUN mkdir nginx
# Download nginx
RUN wget http://nginx.org/download/nginx-1.18.0.tar.gz -O nginx-1.18.tar.gz && \
  tar -xf nginx-1.18.tar.gz
# Configure
RUN (cd /root/nginx-1.18.0 && ./configure --conf-path=/root/nginx-conf/nginx.conf --sbin-path=/root/nginx/ --with-http_ssl_module --add-module=/root/nginx-rtmp/)
# Build
RUN (cd /root/nginx-1.18.0 && make -j64 && make install)
# Clean up the nginx build
RUN rm -rf /root/nginx-1.18.0 && rm -rf /root/nginx-rtmp && rm /root/nginx-1.18.tar.gz

# Copy over the rtmp configuration
COPY ./nginx/nginx.conf ./nginx-conf/nginx.conf
