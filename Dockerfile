FROM debian:latest as builder

RUN apt-get update && apt-get install -y \
   build-essential \
   git \
   asciidoctor

ARG GIT_REPO=https://github.com/compdude22/ndppd.git
RUN git clone ${GIT_REPO}

ARG COMMIT_SHA=main
RUN cd /ndppd && \
   git checkout ${COMMIT_SHA} && \
   make

FROM debian:latest

# Copy binary into image
COPY --from=builder /ndppd/ndppd /usr/local/sbin/

# Add entrypoint
ADD init.sh /init.sh
ENTRYPOINT ["/init.sh"]
