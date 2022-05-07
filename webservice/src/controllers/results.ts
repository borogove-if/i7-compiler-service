/**
 * Accessing the results of a compilation
 */
import { Request, Response } from "express";
import fs, { readFile } from "fs";
import { join } from "path";
import util from "util";

import { STASH_DIR } from "../services/directories";
import { isValidJobId } from "../services/job";
import { parseResultsReport } from "../services/results";

const exists = util.promisify( fs.exists );


/**
 * Returns an index HTML page.
 */
export function getIndex( req: Request, res: Response ): void {
    const { jobId, page } = req.params;

    // validate page filename
    if( !/^[a-z0-9_/]+\.html$/i.test( page ) ) {
        res.status( 400 ).send( "Invalid filename" );
        return;
    }

    const filename = join( STASH_DIR, jobId, page );

    readFile( filename, { encoding: "utf8" }, ( err, data ) => {
        if( err ) {
            return res.status( 404 ).send( "File not found" );
        }

        let contents = data;

        // remove image tags
        contents = contents.replace( /<img .*?>/g, "" );

        // remove background images
        contents = contents.replace( /background="inform:.*?"/g, "" );
        contents = contents.replace( /background-image:url\('inform:.*?'\);?/g, "" );

        res.send( contents );
    });
}

interface ResultsResponse {
    data: {
        report: string;
        success: boolean;
    };
    links?: {
        index: string;
        storyfile: string;
    }
}


/**
 * Sends back links to the resources created by the compilation.
 */
export async function getResults( req: Request, res: Response ): Promise<void> {
    const { jobId } = req.params;
    const jobStashDir = join( STASH_DIR, jobId );
    const outputFile = join( jobStashDir, "output.ulx" );
    const success = await exists( outputFile );
    let report = await parseResultsReport( join( jobStashDir, "Problems.html" ) );

    // Custom error message if the Inform 6 phase failed
    if( !success && report.indexOf( "has successfully been translated into" ) > -1 ) {
        report = `<p>The Inform 7 compiler translated the source text without issues into intermediary Inform 6 code, but the Inform 6 compiler could not further translate it into a playable game file.</p>
<p>This error is usually caused by Inform 6 inclusions, either in the source text or in the project's extensions. If you have included Inform 6 code, check the compiler output for the exact error message given by the Inform 6 compiler and see if it refers to the code in the project's Inform 6 inclusions.</p>`;
    }

    const responseJson: ResultsResponse = {
        data: {
            report,
            success
        }
    };

    if( success ) {
        responseJson.links = {
            index: `${process.env.SERVICE_URL}/results/${jobId}/index/`,
            storyfile: `${process.env.SERVICE_URL}/results/${jobId}/storyfile/output.ulx`
        };
    }

    res.json( responseJson );
}


/**
 * Sends the compiled story file.
 */
export function getStoryfile( req: Request, res: Response ): void {
    const { jobId } = req.params;

    if( !isValidJobId( jobId ) ) {
        res.status( 400 ).send( "Invalid job id" );
        return;
    }

    res.sendFile( join( STASH_DIR, jobId, "output.ulx" ) );
}
