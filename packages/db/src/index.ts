import { drizzle } from 'drizzle-orm/postgres-js'
import postgres from 'postgres'
import * as schema from './schema'
import { env } from './env'

const connectionString = env.DATABASE_URL

// Singleton pattern to prevent connection pool exhaustion in development
// Next.js hot reload creates new module instances, each creating a new pool
const globalForDb = globalThis as unknown as {
  client: postgres.Sql | undefined
}

const client =
  globalForDb.client ??
  postgres(connectionString, {
    max: 10,
    idle_timeout: 20,
    connect_timeout: 10,
  })

// In development, cache the client to avoid connection churn during hot reload.
if (env.NODE_ENV !== 'production') {
  globalForDb.client = client
}

export const db = drizzle(client, { schema })

export type Database = typeof db

// Re-export schema for convenience
export * from './schema'
export {
  activeProductUnitCountSql,
  effectiveProductQuantitySql,
  getEffectiveProductQuantities,
} from './product-quantity'
export {
  buildReservationOverlapPredicate,
  buildUnitInDowntimeAtPredicate,
  buildUnitRentableDuringPredicate,
  findBusyUnitIds,
  getBlockingReservationStatuses,
} from './unit-availability'
export type {
  BlockingReservationStatus,
  BusyUnitReason,
} from './unit-availability'

// Database setup utilities
export { setupDatabase } from './setup'
