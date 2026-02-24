import { defineConfig, env } from 'prisma/config';

export default defineConfig({
  datasource: {
    url: env('DATABASE_URL'),
    ...(process.env.DATABASE_DIRECT_URL ? { directUrl: env('DATABASE_DIRECT_URL') } : {}),
  },
});
