export function exitLegacyMysqlScript(scriptName: string): never {
  console.error(
    `${scriptName} is disabled after the Postgres migration. Port this script to postgres-js before using it against DATABASE_URL.`,
  )
  process.exit(1)
}
