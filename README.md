# docker-iperf

iPerf3 in an Alpine-based Docker image. Small, lightweight and (most importantly) up-to-date with source.

## Running as a server

To run as a server in the foreground:

`docker run -it --rm -p 5201:5201 ingenieurmt/docker-iperf --server`

Or alternatively, you can run it as a daemon in the background:

`docker run -d --name iperf-server -p 5201:5201 ingenieurmt/docker-iperf --server`

## Running as a client

There's a few ways to do this, but the basic gist is:

`docker run -it --rm --network=host ingenieurmt/docker-iperf --client <SERVER_IP> <OPTIONS>`

iPerf has a lot of tunables and options available, these are all documented [here](https://iperf.fr/iperf-doc.php#3doc).
