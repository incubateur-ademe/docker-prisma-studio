FROM node:24.13.0-alpine AS base
ARG DATABASE_URL
ENV DATABASE_URL=${DATABASE_URL}
ENV NODE_ENV=production
COPY .nvmrc .
COPY package.json .
COPY package-lock.json .
RUN npm ci


FROM base AS pull
COPY prisma/ .
COPY prisma.config.ts .
RUN npm run prisma db pull --force
RUN npm run prisma generate

FROM base AS release
ARG PORT
ENV PORT=${PORT}
COPY --from=pull . .
EXPOSE ${PORT}
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]