/**
 * Database Migration Script
 *
 * Runs Drizzle migrations against the Postgres DATABASE_URL.
 *
 * Usage:
 *   pnpm db:migrate:run
 */

import { config } from 'dotenv'
import { migrate } from 'drizzle-orm/postgres-js/migrator'
import postgres from 'postgres'
import path from 'path'
import { fileURLToPath } from 'url'

import { drizzle } from 'drizzle-orm/postgres-js'

// Load environment variables from .env files (order matters - .env.local takes priority)
config({ path: '.env.local' })
config({ path: '.env' })

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const MIGRATIONS_FOLDER = path.join(__dirname, 'migrations')

async function runMigrations() {
  const databaseUrl = process.env.DATABASE_URL

  if (!databaseUrl) {
    console.error('DATABASE_URL environment variable is not set')
    process.exit(1)
  }

  const client = postgres(databaseUrl, { max: 1 })
  const db = drizzle(client)

  try {
    console.log('Running Postgres migrations...')
    await migrate(db, { migrationsFolder: MIGRATIONS_FOLDER })
    console.log('Database migrations completed.')
  } finally {
    await client.end()
  }
}

runMigrations().catch((error) => {
  console.error('Migration failed:', error)
  process.exit(1)
})
