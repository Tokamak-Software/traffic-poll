FROM ubuntu:18.04
RUN apt-get update &&\
  apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev git ffmpeg go

# Add the poller
ADD poller /etc/poller
RUN (cd /etc/poller && go build .)

# Clone nginx rtmp module
RUN git clone https://github.com/sergey-dryabzhinsky/nginx-rtmp-module.git /etc/nginx-rtmp

# Build, compile, and install nginx
RUN wget http://nginx.org/download/nginx-1.18.0.tar.gz -O /etc/nginx-1.18.tar.gz && \
  tar -C /etc/nginx -xf /etc/nginx-1.18.tar.gz &&\
  ./etc/nginx/configure --with-http_ssl_module --add-module=/etc/nginx-rtmp/ && \
RUN make /etc/nginx -j64 && make install
