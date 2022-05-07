/* eslint-disable @typescript-eslint/no-unused-vars */
import type { Response as originalResponse } from "express/index";

/**
 * Extend the Request object to include Sentry's error message
 */
declare global {
    namespace Express {
        interface Response {
            sentry?: string;
        }
    }
}

