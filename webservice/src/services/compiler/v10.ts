import { spawn } from "child_process";
import { join } from "path";
import { promises } from "fs";

import type { CompilationVariant } from "./index";
import { stash } from "./stash";
import { PROJECTS_DIR, ROOT_DIR, V10_ROOT_DIR, VOLUME_DIR } from "../directories";
import { compileI6 } from "./i6";

const INFORM_INSTALLATION_DIR = join( V10_ROOT_DIR, "inform" );
const I6_INSTALLATION_DIR = join( INFORM_INSTALLATION_DIR, "inform6" );
const I7_INSTALLATION_DIR = join( INFORM_INSTALLATION_DIR, "inform7" );
const I6_EXECUTABLE_DIR = join( I6_INSTALLATION_DIR, "Tangled" );
const I7_EXECUTABLE_DIR = join( I7_INSTALLATION_DIR, "Tangled" );
const I7_INTERNAL_DIR = join( I7_INSTALLATION_DIR, "Internal" );
const I6_EXECUTABLE = join( I6_EXECUTABLE_DIR, "inform6" );
const I7_EXECUTABLE = join( I7_EXECUTABLE_DIR, "inform7" );
const INTERNAL_NEST_DIR = join( ROOT_DIR, "nests" );
const FRIENDS_NEST_DIR = join( INTERNAL_NEST_DIR, "friends-of-i7" );
const VOLUME_NEST_DIR = join( VOLUME_DIR, "v10", "nests" );
const VORPLE_NEST_ROOT_DIR = join( VOLUME_NEST_DIR, "Vorple" );

const compilerBuildDate = async( callback: ( content: string ) => boolean ): Promise<void> => {
    const execHandle = await promises.open( I7_EXECUTABLE, "r" );
    const execStats = await execHandle.stat();
    const ctime = execStats.ctime.toISOString().substring( 0, 10 );
    execHandle.close();

    callback( `Starting Inform 7 compiler (build date ${ctime})\n\n` );
};

export async function compile(
    jobId: string,
    variant: CompilationVariant,
    vorpleVersion: string | undefined,
    callback: ( content: string ) => boolean
): Promise < number > {
    const projectDirectory = join( PROJECTS_DIR, jobId + ".inform" );
    const isDebugVersion = variant === "debug";
    const vorpleNestDirectory = vorpleVersion && join( VORPLE_NEST_ROOT_DIR, vorpleVersion );

    const compilerParams = [
        "-internal",
        I7_INTERNAL_DIR,
        "-project",
        projectDirectory,
        "-at",
        I7_INSTALLATION_DIR,
        "-nest",
        FRIENDS_NEST_DIR,
        "-no-census-update"
    ];

    if( vorpleNestDirectory ) {
        compilerParams.push( "-nest" );
        compilerParams.push( vorpleNestDirectory );
    }

    if( isDebugVersion ) {
        compilerParams.push( "-debug" );
    }

    const compilation = spawn( I7_EXECUTABLE, compilerParams );

    // Add the date when the compiler was built to the output
    compilerBuildDate( callback );

    // Send all output to the callback function, which sends the data on to the client.
    // We don't care whether the output is sent to stdout or stderr –
    // Inform uses them both for what would usually be sent to stdout only.
    compilation.stdout.on( "data", callback );
    compilation.stderr.on( "data", callback );

    return new Promise( resolve => compilation.on(
        "close",
        async( exitCode: number ) => {
            // stash the relevant files
            await stash( jobId, exitCode === 0, PROJECTS_DIR );

            if( exitCode !== 0 ) {
                resolve( exitCode );
            }
            else {
                const i6ExitCode = compileI6( I6_EXECUTABLE, projectDirectory, jobId, isDebugVersion, callback );
                resolve( i6ExitCode );
            }
        }
    ) );
}
