#!/bin/sh
exec npx --yes prisma studio --port "${PORT:-5555}" --browser none
