import fs from "fs";

const { readFile } = fs.promises;

/**
 * Parses the compiler's results HTML to find the actual success or error message.
 */
export async function parseResultsReport( filepath: string ): Promise<string> {
    const contents = await readFile( filepath, { encoding: "utf-8" });

    if( !contents || typeof contents !== "string" ) {
        return "No results.";
    }

    const firstParts6M62 = contents.split( "<!--PROBLEMS BEGIN-->" );
    const firstParts6G60 = contents.split( "<p>This is the report produced by Inform 7 (build 6G60) on its most recent run through:<p>" );
    const firstParts = ( firstParts6M62.length < 2 ) ? firstParts6G60 : firstParts6M62;

    if( firstParts.length < 2 ) {
        return contents;
    }

    const secondParts6M62 = firstParts[1].split( "<!--PROBLEMS END-->" );
    const secondParts6G60 = firstParts[1].split( "</font></body></html>" );
    const secondParts = ( secondParts6M62.length < 2 ) ? secondParts6G60 : secondParts6M62;

    if( secondParts.length === 0 ) {
        return contents;
    }

    let message = secondParts[0].trim();

    // replace link to line number
    message = message.replace( /<a href="source:story\.ni#line(\d+)">/g, "(line $1)" );

    // remove other links and images
    message = message.replace( /<a href=(.*?)>/g, "" ).split( "</a>" ).join( "" );
    message = message.replace( /<img (.*?)>/g, "" );

    return message;
}
