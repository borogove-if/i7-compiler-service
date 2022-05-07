import { Router } from "express";
import {
    getIndex,
    getResults,
    getStoryfile
} from "../controllers/results";

// Init router and path
const router: Router = Router();

// Add sub-routes (root: /results)
router.get( "/:jobId", getResults );
router.get( "/:jobId/storyfile/output.ulx", getStoryfile );
router.get( "/:jobId/index/:page", getIndex );

export default router;
