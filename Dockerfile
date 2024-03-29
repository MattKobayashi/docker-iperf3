FROM alpine:3 as buildenv

ENV IPERF3_FILE=iperf3.tar.gz \
    IPERF3_URL=https://github.com/esnet/iperf/archive/3.11.tar.gz \
    IPERF3_SHA1SUM=e3d2489a1242c1cdd07039eda75dc7efef5b702a

# Grab iperf3 from Github and compile
WORKDIR /iperf3
RUN apk --no-cache upgrade \
    && apk add --no-cache tar build-base \
    && wget -O "$IPERF3_FILE" "$IPERF3_URL" \
    && echo "${IPERF3_SHA1SUM}  ${IPERF3_FILE}" | sha1sum -c - \
    && tar -xz --strip-components=1 --file="$IPERF3_FILE" \
    && ./configure \
    && make \
    && make install

FROM alpine:3

# Copy relevant compiled files to distribution image
RUN adduser --system iperf3
COPY --from=buildenv /usr/local/lib/ /usr/local/lib/
COPY --from=buildenv /usr/local/bin/ /usr/local/bin/
COPY --from=buildenv /usr/local/include/ /usr/local/include/
COPY --from=buildenv /usr/local/share/man/ /usr/local/share/man/
RUN ldconfig -n /usr/local/lib \
    && apk --no-cache upgrade

# Switch to 'iperf3' user
USER iperf3

# Set expose port and entrypoint
EXPOSE 5201
ENTRYPOINT ["iperf3"]

LABEL maintainer="matthew@kobayashi.au"
