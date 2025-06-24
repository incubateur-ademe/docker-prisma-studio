#!/bin/sh
rm -f schema.prisma
cat <<EOF > schema.prisma
datasource db {
  provider = "postgresql"
  url      = env("POSTGRES_URL")
}
generator client {
  provider = "prisma-client-js"
}
EOF
echo "Using Postgres URL: $POSTGRES_URL"
npx --yes prisma db pull
echo "Pulled schema from database"
echo "Generating Prisma client"
npx --yes prisma generate
echo "Prisma client generated"
npx --yes prisma studio --port $PRISMA_STUDIO_PORT --browser none