FROM node:22.16.0-alpine AS base
ARG PRISMA_STUDIO_PORT="5555"
ENV PRISMA_STUDIO_PORT=${PRISMA_STUDIO_PORT}
ARG POSTGRES_URL
ENV POSTGRES_URL=${POSTGRES_URL}
ENV NODE_ENV=production
COPY .nvmrc .

FROM base AS pull
COPY schema.prisma .
COPY package.json .
RUN npx --yes prisma db pull --force
RUN npx --yes prisma generate

FROM base AS release
COPY --from=pull . .
EXPOSE $PRISMA_STUDIO_PORT
ENTRYPOINT ["/bin/sh", "npx", "prisma", "--yes", "studio", "--port", "$PRISMA_STUDIO_PORT", "--browser", "none"]