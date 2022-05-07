import express, { Express, Request, Response } from "express";
import * as Sentry from "@sentry/node";

import baseRouter from "../routes";

// Initialize Express
const app: Express = express();

// Initialize Sentry
if( process.env.SENTRY_DSN ) {
    console.log( "Initializing Sentry..." );
    Sentry.init({ dsn: process.env.SENTRY_DSN });

    // The request handler must be the first middleware on the app
    app.use( Sentry.Handlers.requestHandler() );
}

// Add middleware/settings/routes to express.
app.use( express.json({ limit: "1mb" }) );
app.use( express.urlencoded({ extended: true }) );
app.use( "/", baseRouter );

// The error handler must be before any other error middleware and after all controllers
if( process.env.SENTRY_DSN ) {
    app.use( Sentry.Handlers.errorHandler() );
}

app.get( "*", ( _req: Request, res: Response ) => {
    res.status( 404 ).send( "404: page not found" );
});

if( process.env.SENTRY_DSN ) {
    // Optional fallthrough error handler
    app.use( ( _err: Error, _req: Request, res: Response ) => {
        // The error id is attached to `res.sentry` to be returned
        // and optionally displayed to the user for support.
        res.statusCode = 500;
        res.end( res.sentry + "\n" );
    });
}

// Export express instance
export default app;
