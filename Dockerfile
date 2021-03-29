FROM alpine:latest AS build
ARG VERSION
RUN apk add --no-cache alpine-sdk go linux-headers
RUN git clone --depth 1 -b v${VERSION} https://github.com/binance-chain/bsc.git /opt/bsc
WORKDIR /opt/bsc
RUN make geth
RUN wget https://github.com/binance-chain/bsc/releases/download/v${VERSION}/mainnet.zip
RUN mkdir -p /opt/bsc-mainnet && unzip mainnet.zip -d /opt/bsc-mainnet

FROM alpine:latest
COPY --from=build /opt/bsc/build/bin/geth /usr/local/bin/
COPY --from=build /opt/bsc-mainnet /usr/share/
RUN adduser -D -u 1000 runner
USER runner
WORKDIR /home/runner
RUN /usr/local/bin/geth --nousb --datadir node init /usr/share/genesis.json
EXPOSE 8545 8546 8547 30303 30303/udp
ENTRYPOINT ["geth"]
