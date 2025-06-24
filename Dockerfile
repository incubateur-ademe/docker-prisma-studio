FROM node:22.16.0-alpine
COPY run.sh .
RUN chmod +x run.sh
EXPOSE $PRISMA_STUDIO_PORT
ENTRYPOINT ["/bin/sh", "run.sh"]