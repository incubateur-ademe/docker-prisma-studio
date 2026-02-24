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
ARG SCHEMA_URL
COPY prisma/ .
COPY prisma.config.ts .
RUN if [ -n "${SCHEMA_URL}" ]; then \
      wget -q -O schema.prisma "${SCHEMA_URL}"; \
    else \
      pnpm prisma db pull --force; \
    fi
RUN pnpm prisma generate

FROM base AS release
ARG PORT
ENV PORT=${PORT}
COPY --from=pull . .
EXPOSE ${PORT}
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]