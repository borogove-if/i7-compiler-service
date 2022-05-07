import fs from "fs";
import { join } from "path";
import copyDir from "recursive-copy";
import rimraf from "rimraf";
import { promisify } from "util";

import { PROJECTS_DIR, TEMPLATES_DIR } from "../directories";
import { compile as legacyCompile } from "./legacy";
import { compile as v10Compile } from "./v10";
import { validateCompilerVersion } from "./validation";

const { mkdir, writeFile } = fs.promises;

// turn the directory removing function to something that returns a promise instead of requiring a callback
const rmdirRecursive = promisify( rimraf );

type CompilerVersion = "6G60" | "6M62" | "10.1.0";

/**
 * Compilation request's basic data
 */
interface ProjectData {
    compilerVersion: CompilerVersion;
    debug?: boolean;
    language: "inform7" | "Inform 7";   // should be just "inform7", the "Inform 7" option is for backwards compatibility
    sessionId: string;
    uuid: string;
}

/**
 * File information in compilation requests
 */
interface ProjectFile {
    type: "file";
    attributes: {
        name: string;
        directory: string;
        contents: string;
    };
}

/**
 * What compilation variant to use (debug or release)
 */
export type CompilationVariant = "debug" | "release";


/**
 * Deletes the build files for a compilation job.
 */
function cleanup( jobId: string ): void {
    const projectRoot = PROJECTS_DIR;
    const projectDirectory = join( projectRoot, jobId + ".inform" );
    const materialsDirectory = join( projectRoot, jobId + ".materials" );

    // remove the directories – if they don't exist, that's ok
    try {
        rmdirRecursive( projectDirectory );
    } catch( e ) {
        // do nothing
    }

    try {
        rmdirRecursive( materialsDirectory );
    } catch( e ) {
        // do nothing
    }
}

function isValidFilename( filename: string ): boolean {
    // regex from https://github.com/sindresorhus/filename-reserved-regex
    // eslint-disable-next-line no-control-regex
    return !/[<>:"/\\|?*\u0000-\u001F]/g.test( filename );
}


/**
 * Compile Inform 7 source text into a game file. Compiler output will be
 * streamed to the callback.
 *
 * It's expected that the input values have already been validated
 * (e.g. session should be a safe string because it's used as a filename.)
 *
 * The function returns the same error code the compiler returns,
 * or throws an internal error.
 */
export async function compile(
    jobId: string,
    variant: CompilationVariant,
    compilerVersion: string,
    callback: ( content: string ) => boolean
): Promise <number> {
    validateCompilerVersion( compilerVersion );
    const isV10 = compilerVersion.indexOf( "10" ) === 0;

    if( isV10 ) {
        return v10Compile( jobId, variant, callback );
    }
    else {
        return legacyCompile( jobId, variant, compilerVersion, callback );
    }
}

export async function prepare( data: ProjectData, files: ProjectFile[] ): Promise<string> {
    const { compilerVersion, language, sessionId, uuid } = data;

    const jobId = sessionId.replace( /[^0-9a-z-]/ig, "" );

    if( jobId.length === 0 || jobId.length > 100 ) {
        throw new Error( "Invalid session id" );
    }

    if( language !== "inform7" && language !== "Inform 7" ) {
        throw new Error( "Unknown language id " + language );
    }

    validateCompilerVersion( compilerVersion );

    const templateDirectory = join( TEMPLATES_DIR, `Template.${compilerVersion}.inform` );
    const projectDirectory = join( PROJECTS_DIR, jobId + ".inform" );
    const materialsDirectory = join( PROJECTS_DIR, jobId + ( compilerVersion === "6G60" ? " Materials" : ".materials" ) );
    const extensionsDirectory = join( materialsDirectory, "Extensions" );
    const uuidFilename = join( projectDirectory, "uuid.txt" );
    const sourceTextFilename = join( projectDirectory, "Source", "story.ni" );

    let sourceText: string | undefined;
    const extensions: Array<ProjectFile["attributes"]> = [];

    files.forEach( ( file: ProjectFile ) => {
        if( !file.attributes ) {
            throw new Error( "Invalid file format" );
        }

        const { contents, directory, name } = file.attributes;

        if( file.type !== "file" ) {
            throw new Error( "Only 'file' resource types are supported" );
        }

        // check if this is the source text
        if( name === "story.ni" ) {
            if( directory !== "Source" ) {
                throw new Error( "Source text (story.ni) is allowed only in the Source directory" );
            }

            sourceText = contents;
            return;
        }

        // anything else is an extension

        // check directory, we assume that there is no leading slash
        if( !directory.startsWith( "Extensions/" ) || directory.split( "/" ).length > 2 ) {
            throw new Error( "Extensions are allowed only in the Extensions directory" );
        }

        if( !isValidFilename( name ) ) {
            throw new Error( "Invalid extension filename" );
        }

        const authorDirectory = directory.split( "/" )[ 1 ];

        if( !isValidFilename( authorDirectory ) ) {
            throw new Error( "Invalid extension directory name" );
        }

        extensions.push( file.attributes );
    });

    if( !sourceText ) {
        throw new Error( "No source text found" );
    }

    try {
        await rmdirRecursive( projectDirectory );
        await rmdirRecursive( materialsDirectory );
        await copyDir( templateDirectory, projectDirectory );
        await writeFile( uuidFilename, uuid, { encoding: "utf8", flag: "w" });
        await writeFile( sourceTextFilename, sourceText, { encoding: "utf8", flag: "w" });
        await mkdir( materialsDirectory );
        await mkdir( extensionsDirectory );

        for( const extension of extensions ) {
            await mkdir( join( materialsDirectory, extension.directory ) );
            await writeFile(
                join( materialsDirectory, extension.directory, extension.name ),
                extension.contents
            );
        }
    } catch( e ) {
        // make sure no files or directories are left if something goes wrong
        cleanup( jobId );
        throw e;
    }

    return jobId;
}
