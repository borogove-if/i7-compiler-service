import { Router } from "express";
import { checkSpace, ping } from "../controllers/monitoring";

// Init router and path
const router: Router = Router();

// Add sub-routes (root: /monitoringRoutes)
router.get( "/ping", ping );
router.get( "/storage", checkSpace );

export default router;
