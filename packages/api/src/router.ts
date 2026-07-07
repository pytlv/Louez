import { dashboardRouter } from './routers/dashboard'
import { publicRouter } from './routers/public'
import { storefrontRouter } from './routers/storefront'

/**
 * Root application router
 * Combines all sub-routers for dashboard and storefront
 */
export type AppRouter = {
  public: typeof publicRouter
  dashboard: typeof dashboardRouter
  storefront: typeof storefrontRouter
}

export const appRouter: AppRouter = {
  public: publicRouter,
  dashboard: dashboardRouter,
  storefront: storefrontRouter,
}
