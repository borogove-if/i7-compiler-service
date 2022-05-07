import { Router } from "express";

import compilerRoutes from "./compilerRoutes";
import monitoringRoutes from "./monitoringRoutes";
import resultRoutes from "./resultRoutes";
import corsMiddleware from "../server/corsMiddleware";

// Init router and path
const router: Router = Router();

// Add sub-routes
router.use( "/", corsMiddleware, compilerRoutes );
router.use( "/results", corsMiddleware, resultRoutes );
router.use( "/monitoring", monitoringRoutes );

// Export the base-router
export default router;
