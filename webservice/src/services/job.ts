/**
 * Checks that a job id is valid.
 */
export const isValidJobId = ( id: string ): boolean => typeof id === "string" && id.length > 0 && id.length < 100 && /^[0-9a-z-]+$/i.test( id );
