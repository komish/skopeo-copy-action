FROM docker.io/golang:1.18 as builder

RUN mkdir /skopeo-bin
# Skopeo dependencies
RUN apt update && apt install -y libgpgme-dev libassuan-dev libbtrfs-dev libdevmapper-dev pkg-config
# Get the source from releases
RUN wget -q https://github.com/containers/skopeo/archive/refs/tags/v1.8.0.tar.gz && tar xzf v1.8.0.tar.gz \
    && cd skopeo-1.8.0 && make bin/skopeo && mv bin/skopeo /skopeo-bin/skopeo-1.8.0 && cd ..
RUN wget -q https://github.com/containers/skopeo/archive/refs/tags/v1.7.0.tar.gz && tar xzf v1.7.0.tar.gz \
    && cd skopeo-1.7.0 && make bin/skopeo && mv bin/skopeo /skopeo-bin/skopeo-1.7.0 && cd .. \
    && chmod +x /skopeo-bin/*

# This base image should match the same base OS used in the builder to increase
# the likelihood shared libraries will match.
FROM docker.io/debian:bullseye
RUN apt update && apt install -y libgpgme-dev libassuan-dev libbtrfs-dev libdevmapper-dev pkg-config \
    golang-github-containers-common ca-certificates
WORKDIR /opt
COPY --from=builder /skopeo-bin skopeo-bin
COPY run.sh run.sh
COPY transports transports

ENTRYPOINT "/opt/run.sh"
