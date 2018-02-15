FROM alpine:edge AS builder

RUN apk add --no-cache \
    build-base \
    cmake \
    git \
    libuv-dev \
  && git clone https://github.com/xmrig/xmrig.git /xmrig \
  && mkdir /xmrig/build \
  && cd /xmrig/build \
  && cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DWITH_HTTPD=OFF \
    -DCMAKE_EXE_LINKER_FLAGS="-static" \
    -DCMAKE_FIND_LIBRARY_SUFFIXES=".a" \
  && make -j$(nproc) \
  && strip ./xmrig

FROM scratch

COPY --from=builder /xmrig/build/xmrig /

ENTRYPOINT ["/xmrig"]
