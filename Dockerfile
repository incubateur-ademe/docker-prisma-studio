FROM node:24.13.1-alpine AS base
ARG DATABASE_URL
ENV DATABASE_URL=${DATABASE_URL}
ENV NODE_ENV=production
WORKDIR /app
RUN apk upgrade --no-cache && npm install -g npm@latest && corepack enable
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN corepack install && pnpm install --frozen-lockfile


FROM base AS pull
ARG SCHEMA_URL
COPY prisma/ ./prisma/
COPY prisma.config.ts ./
RUN if [ -n "${SCHEMA_URL}" ]; then \
    wget -q -O prisma/schema.prisma "${SCHEMA_URL}"; \
    else \
    pnpm prisma db pull --force; \
    fi && \
    sed -i '/^\s*url\s*=/d; /^\s*directUrl\s*=/d' prisma/schema.prisma
RUN pnpm prisma generate

FROM base AS release
ARG PORT
ENV PORT=${PORT}
COPY --from=pull /app /app
EXPOSE ${PORT}
COPY --chmod=755 entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
