import { spawn } from "child_process";
import fs from "fs";
import { join } from "path";

import { STASH_DIR } from "../directories";

const { copyFile } = fs.promises;

export const compileI6 = ( executable: string, projectDirectory: string, jobId: string, debug: boolean, callback: ( text: string ) => void ): Promise<number> => {
    const buildDirectory = join( projectDirectory, "Build" );

    return new Promise( resolve => {
        const i6Step = spawn(
            executable,
            [
                debug ? "-kE2SDwG" : "-kE2~S~DwG",
                "auto.inf"
            ],
            {
                cwd: buildDirectory
            }
        );

        i6Step.stdout.on( "data", callback );
        i6Step.stderr.on( "data", callback );
        i6Step.on( "close", async( i6ExitCode: number ) => {
            if( i6ExitCode === 0 ) {
                await copyFile(
                    join( buildDirectory, "auto.ulx" ),
                    join( STASH_DIR, jobId, "output.ulx" )
                );
            }
            resolve( i6ExitCode );
        });
    });
};
