FROM node:24.13.0-alpine AS base
ARG DATABASE_URL
ENV DATABASE_URL=${DATABASE_URL}
ENV NODE_ENV=production
COPY .nvmrc .
COPY package.json .
COPY pnpm-lock.yaml .
COPY pnpm-workspace.yaml .
RUN corepack enable
RUN corepack install
RUN pnpm install --frozen-lockfile


FROM base AS pull
COPY prisma/ .
COPY prisma.config.ts .
RUN pnpm prisma db pull --force
RUN pnpm prisma generate

FROM base AS release
ARG PORT
ENV PORT=${PORT}
COPY --from=pull . .
EXPOSE ${PORT}
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]