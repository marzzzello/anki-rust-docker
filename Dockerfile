FROM alpine:latest
ARG VERSION
ARG PLATFORM=linux
WORKDIR /app
RUN if [[ -z "$VERSION" ]] ; then \
    wget -q https://api.github.com/repos/ankicommunity/anki-sync-server-rs/releases/latest -O - \
    | grep "browser_download_url.*tar.gz" | cut -d : -f 2,3 | tr -d \" | grep ${PLATFORM} | xargs wget -O ankisyncd.tar.gz -q; \
    else \
    wget https://github.com/ankicommunity/anki-sync-server-rs/releases/download/${VERSION}/ankisyncd-${VERSION}-${PLATFORM}.tar.gz -O ankisyncd.tar.gz; \
    fi \
    && tar -xf ankisyncd.tar.gz \
    && rm ankisyncd.tar.gz \
    && mv ankisyncd-${PLATFORM}/ankisyncd /usr/local/bin/ankisyncd \
    && mv ankisyncd-${PLATFORM}/Settings.toml . \
    && rmdir ankisyncd-${PLATFORM}

ENTRYPOINT ["ankisyncd"]
HEALTHCHECK --interval=30s --timeout=3s CMD wget --spider -q http://0.0.0.0:27701
EXPOSE 27701
