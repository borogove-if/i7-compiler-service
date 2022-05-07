import cors, { CorsOptions } from "cors";

/**
 * Parses the CORS_WHITELIST env variable into an array
 */
const parseWhitelist = (): string[] => {
    const { CORS_WHITELIST } = process.env;

    if( !CORS_WHITELIST ) {
        return [];
    }

    return CORS_WHITELIST.split( "," ).map( url => url.trim() );
};

const whitelist: string[] = parseWhitelist();

const corsOptions: CorsOptions = {
    origin( origin: string | undefined, callback: ( err: Error | null, origin?: boolean ) => void ) {
        if( !origin ) {
            callback( null, true );
            return;
        }

        if( whitelist[0] === "*" ) {
            callback( null, true );
            return;
        }

        if( whitelist.includes( origin ) ) {
            callback( null, true );
            return;
        }

        callback( new Error( `Origin ${origin} not allowed by CORS` ) );
    }
};

/**
 * A middleware that sets the CORS headers based on the CORS_WHITELIST env variable
 */
const corsMiddleware = cors( corsOptions );

export default corsMiddleware;
