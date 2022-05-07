import checkDiskSpace from "check-disk-space";
import type { Request, Response } from "express";


/**
 * Checks the disk space usage and returns a HTTP 500 error if it's above the given treshold.
 * A separate monitoring service can call this endpoint and raise an alert if it gets the 500 response.
 */
export const checkSpace = async( _req: Request, res: Response ): Promise<void> => {
    const diskSpace = await checkDiskSpace( "/" );
    const used = ( 1 - diskSpace.free / diskSpace.size ) * 100;
    const treshold = process.env.DISKSPACE_ALERT_TRESHOLD ? Number( process.env.DISKSPACE_ALERT_TRESHOLD ) : 99;

    if( used >= treshold ) {
        res.status( 500 ).send( "Disk space about to run out!" );
    }

    res.send( "Disk space ok" );
};


/**
 * Sends "pong" as a response to a ping request.
 */
export const ping = ( _req: Request, res: Response ): void => {
    res.send( "pong" );
};
