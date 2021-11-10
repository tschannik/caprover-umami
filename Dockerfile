# Build image
FROM ghcr.io/mikecao/umami:postgresql-2575cbf
USER root

RUN apk add --no-cache postgresql-client

COPY database-setup.sql database-setup.sql
COPY wait-for-it.sh wait-for-it.sh
COPY entrypoint.sh entrypoint.sh

RUN chmod +x entrypoint.sh

RUN chown node database-setup.sql
RUN chown node wait-for-it.sh
RUN chown node entrypoint.sh

USER node

EXPOSE 3000
ENTRYPOINT [ "./entrypoint.sh" ]