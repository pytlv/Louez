import { config } from 'dotenv'
import { defineConfig } from 'drizzle-kit'
import { resolve } from 'path'

const rootDir = resolve(process.cwd(), '../..')
config({ path: resolve(rootDir, '.env.local') })
config({ path: resolve(rootDir, '.env') })

const databaseUrl = process.env.DATABASE_URL

if (!databaseUrl) {
  throw new Error('DATABASE_URL is required. Set it in the root .env.local file.')
}

export default defineConfig({
  schema: './src/schema.ts',
  out: './src/migrations',
  dialect: 'postgresql',
  dbCredentials: {
    url: databaseUrl,
  },
  verbose: true,
  strict: true,
})
