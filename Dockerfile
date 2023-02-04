# Copyright (c) 2023 nggit.

FROM debian:bullseye

# update system & install packages
RUN apt-get update && apt-get -y upgrade; \
    DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install python3 python3-pip; \
    python3 -m pip install --upgrade orjson python-dotenv tremolo uvloop

# clean up
RUN apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    find /var/log -name "*.log" -type f -delete

# create a non-root user
RUN useradd --home-dir /app --create-home --user-group app

ADD https://raw.githubusercontent.com/nggit/tremolo-hello/master/src/hello.py /app/hello.py

WORKDIR /app
ENTRYPOINT ["/usr/bin/env", "--"]
CMD ["sh", "-c", "chown -R app:app /app; \
    su -c \"export HOST=$HOST PORT=$PORT; echo Listening at $HOST port $PORT...; \
    while :; do python3 hello.py; echo Restarting...; sleep 1; done\" - app"]
