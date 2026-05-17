FROM alpine:3.19 AS downloader

ARG GOSHS_VERSION=2.0.8
ARG TARGETARCH

RUN apk add --no-cache ca-certificates curl tar && \
    case "${TARGETARCH}" in \
        "amd64") ARCH="x86_64" ;; \
        "arm64") ARCH="arm64" ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    curl -fsSL \
        "https://github.com/patrickhener/goshs/releases/download/v${GOSHS_VERSION}/goshs_v${GOSHS_VERSION}_linux_${ARCH}.tar.gz" \
        -o /tmp/goshs.tar.gz && \
    tar -xzf /tmp/goshs.tar.gz -C /tmp && \
    find /tmp -maxdepth 2 -name "goshs" -type f | head -1 | xargs -I{} cp {} /usr/local/bin/goshs && \
    chmod +x /usr/local/bin/goshs

FROM alpine:3.19
RUN apk add --no-cache ca-certificates
COPY --from=downloader /usr/local/bin/goshs /usr/local/bin/goshs
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]
