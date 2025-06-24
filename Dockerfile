FROM node:22.16.0-alpine AS base
ARG POSTGRES_URL
ENV POSTGRES_URL=${POSTGRES_URL}
ENV NODE_ENV=production
COPY .nvmrc .

FROM base AS pull
COPY prisma/ .
COPY package.json .
RUN npx --yes prisma db pull --force
RUN npx --yes prisma generate

FROM base AS release
ARG PORT
ENV PORT=${PORT}
COPY --from=pull . .
EXPOSE ${PORT}
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]