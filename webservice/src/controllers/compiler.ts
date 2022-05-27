import { Request, Response } from "express";
import { compile, prepare } from "../services/compiler";

/**
 * Prepares for compiling source text. The client sends the source material and the server replies with the job id
 * and compiler version that will be used in the actual compilation phase.
 */
export async function prepareCompilation( req: Request, res: Response ): Promise<void> {
    const { data, included } = req.body;

    if( !data || !included ) {
        res.status( 400 ).json({ error: "Invalid request body" });
    }

    try {
        const attributes = await prepare( data, included );

        res.json({
            data: {
                attributes
            }
        });
    } catch( e ) {
        res.json({
            error: ( e as Error ).message
        });
        throw e;
    }
}

export async function startCompilation( req: Request, res: Response ): Promise<void> {
    const { compilerVersion, jobId, variant } = req.params;
    const vorpleVersion = typeof req.query.vorpleVersion === "string" ? req.query.vorpleVersion : undefined;

    res.writeHead(
        200,
        {
            "Cache-control": "no-cache",
            "Content-Type": "text/event-stream"
        }
    );

    if( variant !== "debug" && variant !== "release" ) {
        res.end( "Unknown release variant" );
        return;
    }

    let exitCode: number;

    try {
        exitCode = await compile(
            jobId,
            variant,
            compilerVersion,
            vorpleVersion,
            ( content: string ) => res.write( content )
        );
    } catch( e ) {
        console.error( e );
        res.end( "Unknown compilation error" );
        return;
    }

    res.end( "\nBuild process ended with exit code " + exitCode );
}
