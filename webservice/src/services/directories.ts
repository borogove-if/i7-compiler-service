import { join } from "path";

export const ROOT_DIR = "/usr/src";
export const INFORM_INSTALL_DIR = join( ROOT_DIR, "inform7" );
export const VOLUME_DIR = join( ROOT_DIR, "volume" );
export const STASH_DIR = join( VOLUME_DIR, "Stash" );
export const PROJECTS_DIR = join( VOLUME_DIR, "Projects" );
export const TEMPLATES_DIR = join( VOLUME_DIR, "templates" );
export const LEGACY_ROOT_DIR = INFORM_INSTALL_DIR;
export const V10_ROOT_DIR = join( INFORM_INSTALL_DIR, "v10" );
