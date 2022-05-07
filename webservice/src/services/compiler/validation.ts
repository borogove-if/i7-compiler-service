const SUPPORTED_COMPILER_VERSIONS = process.env.SUPPORTED_COMPILER_VERSIONS?.split( "," ).map( version => version.trim() );

if( !SUPPORTED_COMPILER_VERSIONS ) {
    throw new Error( "SUPPORTED_COMPILER_VERSIONS env variable missing" );
}

export const validateCompilerVersion = ( compilerVersion: string ): void => {
    if( !SUPPORTED_COMPILER_VERSIONS.includes( compilerVersion ) ) {
        if( !compilerVersion ) {
            throw new Error( "Missing compiler version" );
        }
        throw new Error( "Invalid compiler version " + compilerVersion );
    }
};
