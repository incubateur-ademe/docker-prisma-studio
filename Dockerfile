FROM node:22.16.0-alpine AS base

FROM base AS pull
COPY schema.prisma .

ENV NODE_ENV=production
RUN npx --yes prisma db pull --force
RUN npx --yes prisma generate

FROM base AS release
COPY --from=pull . .
EXPOSE $PRISMA_STUDIO_PORT
ENTRYPOINT ["/bin/sh", "npx", "prisma", "--yes", "studio", "--port", "$PRISMA_STUDIO_PORT", "--browser", "none"]