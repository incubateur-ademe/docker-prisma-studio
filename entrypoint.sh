#!/bin/sh
exec pnpm prisma studio --port "${PORT:-5555}" --browser none
