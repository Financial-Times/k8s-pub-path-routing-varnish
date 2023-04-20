# Starting from Ubuntu and not from alpine, as libvmod-dynamic used for generating dynamic backends
# compiles currently only on debian based images.
FROM ubuntu:jammy

# Install build dependencies
RUN apt-get update && \
    apt-get install -y curl apt-transport-https gnupg && \
    curl -L https://packagecloud.io/varnishcache/varnish60lts/gpgkey | apt-key add - && \
    echo "deb https://packagecloud.io/varnishcache/varnish60lts/ubuntu/ jammy main" | tee /etc/apt/sources.list.d/varnish-cache.list && \
    apt-get update && \
    apt-get install -y libgetdns-dev varnish=6.0.11-1~jammy varnish-dev=6.0.11-1~jammy

# Clone and compile libvmod-dynamic
RUN apt-get -y install git autotools-dev automake autoconf libtool make docutils-common
RUN git clone -b 6.0 https://github.com/nigoroll/libvmod-dynamic.git /tmp/libvmod-dynamic && \
    cd /tmp/libvmod-dynamic && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

# Remove build dependencies and clean up
RUN apt-get remove -y curl apt-transport-https gnupg git autotools-dev automake autoconf libtool make docutils-common varnish-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /
COPY default.vcl /etc/varnish/default.vcl
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose port and start
EXPOSE 80
CMD ["/start.sh"]
