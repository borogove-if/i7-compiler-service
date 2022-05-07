import { Router } from "express";
import { prepareCompilation, startCompilation } from "../controllers/compiler";

// Init router and path
const router: Router = Router();

// Add sub-routes
router.post( "/prepare", prepareCompilation );
router.get( "/compile/:compilerVersion/:jobId/:variant", startCompilation );

export default router;
