FROM alpine:3.12 as buildenv

# Grab iperf3 from Github and compile
WORKDIR /iperf3
RUN apk add --no-cache tar build-base \
    && wget -O - https://github.com/esnet/iperf/archive/3.9.tar.gz \
    | tar -xz --strip 1 \
    && ./configure \
    && make \
    && make install

FROM alpine:3.12

# Copy relevant compiled files to distribution image
RUN adduser --system iperf3
COPY --from=buildenv /usr/local/lib/ /usr/local/lib/
COPY --from=buildenv /usr/local/bin/ /usr/local/bin/
COPY --from=buildenv /usr/local/include/ /usr/local/include/
COPY --from=buildenv /usr/local/share/man/ /usr/local/share/man/
RUN ldconfig -n /usr/local/lib

# Switch to 'iperf3' user
USER iperf3

# Set expose port and entrypoint
EXPOSE 5201
ENTRYPOINT ["iperf3"]

LABEL maintainer="matthew@thompsons.id.au"
