import fs from "fs";
import { join } from "path";
import copyDir from "recursive-copy";
import rimraf from "rimraf";
import { promisify } from "util";

import { STASH_DIR } from "../../services/directories";

const { copyFile, mkdir } = fs.promises;

const rmdirRecursive = promisify( rimraf );


/**
 * Store the results of a compilation.
 */
export const stash = async( jobId: string, success: boolean, projectsRootDirectory: string ): Promise<void> => {
    const stashDirectory = join( STASH_DIR, jobId );
    const projectDirectory = join( projectsRootDirectory, jobId + ".inform" );

    // clear old stash
    await rmdirRecursive( stashDirectory );
    await mkdir( stashDirectory );

    // copy Index files
    await copyDir( join( projectDirectory, "Index" ), stashDirectory );

    // Problems.html contains also the success message
    await copyFile(
        join( projectDirectory, "Build", "Problems.html" ),
        join( stashDirectory, "Problems.html" )
    );
};
