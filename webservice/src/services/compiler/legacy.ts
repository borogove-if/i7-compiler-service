import { spawn } from "child_process";
import { join } from "path";

import type { CompilationVariant } from "./index";
import { stash } from "./stash";
import { PROJECTS_DIR, LEGACY_ROOT_DIR, VOLUME_DIR } from "../directories";
import { compileI6 } from "./i6";

export async function compile(
    jobId: string,
    variant: CompilationVariant,
    compilerVersion: string,
    callback: ( content: string ) => boolean
): Promise < number > {
    const projectDirectory = join( PROJECTS_DIR, jobId + ".inform" );
    const i7InstallationDirectory = join( LEGACY_ROOT_DIR, compilerVersion );
    const i7ExecutableDirectory = join( i7InstallationDirectory, "libexec" );
    const i7Executable = join( i7ExecutableDirectory, "ni" );
    const i6Executable = join( i7ExecutableDirectory, compilerVersion === "6G60" ? "inform-6.32-biplatform" : "inform6" );
    const internalDirectory6M62 = join( i7InstallationDirectory, "share", "inform7", "Internal" );
    const internalDirectory6G60 = join( i7InstallationDirectory, "share", "inform7", "Inform7", "Extensions" );
    const i7ExternalDirectory = join( VOLUME_DIR, "legacy", "Inform" );
    const isDebugVersion = variant === "debug";

    const compilerParams = compilerVersion === "6G60" ? [
        "--rules", internalDirectory6G60,
        "--extension=ulx",
        "--package", projectDirectory
    ] : [
        "-internal", internalDirectory6M62,
        "-format=ulx",
        "-project", projectDirectory,
        "-external", i7ExternalDirectory
    ];

    if( !isDebugVersion ) {
        compilerParams.push( "-release" );
    }

    const compilation = spawn( i7Executable, compilerParams );

    // Send all output to the callback function, which sends the data on to the client.
    // We don't care whether the output is sent to stdout or stderr –
    // Inform uses them both for what would usually be sent to stdout only.
    compilation.stdout.on( "data", callback );
    compilation.stderr.on( "data", callback );

    return new Promise( ( resolve ) => compilation.on(
        "close",
        async( exitCode: number ) => {
            // stash the relevant files
            await stash( jobId, exitCode === 0, PROJECTS_DIR );

            if( exitCode !== 0 ) {
                resolve( exitCode );
            }
            else {
                const i6ExitCode = compileI6( i6Executable, projectDirectory, jobId, isDebugVersion, callback );
                resolve( i6ExitCode );
            }
        }
    ) );
}
