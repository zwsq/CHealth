FROM alpine:latest AS base
RUN apk update && \
    apk add docker
COPY chealth.sh /usr/local/bin/
WORKDIR /usr/local/bin/
RUN chmod +x chealth.sh
FROM alpine:latest
COPY --from=base /usr/local/bin/chealth.sh /usr/local/bin/
WORKDIR /usr/local/bin/
RUN chmod +x chealth.sh
CMD ["./chealth.sh"]