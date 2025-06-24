FROM node:22.16.0-alpine AS base
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
ARG PORT
ENV PORT=${PORT}
COPY --from=pull . .
EXPOSE ${PORT}
ENTRYPOINT ["npx", "--yes", "prisma", "studio", "--port", "${PORT}", "--browser", "none"]