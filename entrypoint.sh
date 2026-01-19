#!/bin/sh
exec npm run prisma studio --port "${PORT:-5555}" --browser none
