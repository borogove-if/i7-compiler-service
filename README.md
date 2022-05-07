This is the source code of an online compiler service for the [Inform 7](https://inform7.com) language. The service receives Inform 7 source code as a POST request, compiles the code, and returns links to download the resulting files: the compiled story file and the project index.

The service runs in a [Docker](https://docker.com) container that contains a Node/Express web server and the compilers. It can be run without Docker, but running the service inside a container is highly recommended because there is a small but non-zero chance that the compilers might have exploitable bugs that let an attacker gain wider access to the system by sending specifically crafted source code. Keeping the service inside Docker restricts the potential damage to the container.


## Installation

Edit the production.env file to set up the service.

Running the container with Docker Compose:

```bash
docker-compose -f docker-compose.yml -f docker-compose.production.yml up --build --renew-anon-volumes -d
```

The `--build --renew-anon-volumes` part makes it build the container from scratch. It can be left out to restart the service faster when nothing has changed.

Running the container just with Docker without Compose requires providing the necessary settings from docker-compose.yml files by other means, either by adding them as command line options or editing the Dockerfile.


## Development

Running the project locally with [Docker Compose](https://docs.docker.com/compose/):

```bash
docker-compose up --build
```

(It's `docker compose` without the hyphen in some environments.)

Local setup is in the development.env file. See production.env for descriptions of the values. If you don't change anything in the setup it runs locally in http://localhost:3010.

Note that on a Mac the Inform 6 compilation phase can take several minutes due to how Docker file access works.

Tip: you can enter the running container by commanding `docker exec -ti NAME "/bin/bash"` where NAME is the name of the container (shown at the start of each line in Docker Compose output.)


## Hardware requirements

The service runs well on 1 GB memory, at least when traffic isn't heavy, but the container builds the new 10.1.0 Inform compiler from source which takes literally hours with just 1 GB memory. 2 GB should be enough to build the compiler in just a few minutes. 

If the server where the service is installed has low memory it's recommended to either raise the memory limit temporarily for building the container if possible, or building the image on a separate machine beforehand and uploading it to the server. If the service is used only for the older compilers, the new compiler can be disabled (see below.) The legacy compilers (6G60/6M62) don't require large amounts of resources to install.

The project build files take up relatively large amounts of storage space, but 10 GB total space (including OS and Docker containers) should be enough for light use if the build files are cleaned up regularly. 20 GB is more than enough for most reasonable purposes.

Note that the legacy compilers (6M62 and older) require a x64 architecture platform. For example AWS's newer Arm-based EC2 instances can't be used.

The service hasn't been tested on Windows servers.


## Inform versions

The service comes with Inform 7 compiler versions 6G60, 6M62 and 10.1.0. In the code the 6G60 and 6M62 compilers are identified as "legacy" and the 10.x compiler is "v10".

The SUPPORTED_COMPILER_VERSIONS environment variable can be used to set which versions are available. If a compiler version isn't in that list, a request to compile using that version is rejected even if the compiler is installed.

The commands that install compiler versions are in the file called Dockerfile in the root directory. Remove or comment out the relevant lines to stop the service from installing that version. The SUPPORTED_COMPILER_VERSIONS variable by itself doesn't affect what gets installed.

For now the service installs version 10 by downloading [the latest version](https://github.com/ganelson/inform) from GitHub and compiling it from source. This will change in the future when prebuilt Inform packages become available. The downside of this method is that if something changes in the source repositories, e.g. the compilation process changes or there's a commit that breaks something else, this container breaks as well. In such case you can change the `git clone` commands in Dockerfile to get earlier commits that are known to work.


## Extensions

Extensions for 6G60/6M62 can be placed in the volume/legacy/Inform/Extensions directory. They will be included in the compilation process.

Sending project-specific extensions and 10.1.0 extensions aren't implemented yet.


## Running with Borogove

The service was made for the [Borogove](https://github.com/borogove-if/borogove-ide) online IDE. To run it with a custom installation of Borogove, set the environment variables in Borogove to point to where the compiler service is installed. The URL to set to Borogove's REACT_APP_I7_COMPILER_SERVICE_URL variable is the same as the service's SERVICE_URL variable.

The compiler selection that Borogove offers is defined in the src/services/projects/inform7/inform7VanillaProjectService.ts file in the compilerVersions variable. If you disable compiler versions from the compiler service, they should be removed from that file as well.

If you remove compiler options, also remember to check Borogove's REACT_APP_DEFAULT_I7_COMPILER_VERSION environment variable so that it won't point to a non-existing version.


## Compiler usage

The compilation process is as follows:

1. Send the Inform source text and project information to /prepare
2. Tell the compiler to start compiling by calling /compile
3. Check the results from /results
4. If compilation was successful, download the compiled story file and index

### 1. Preparing the project

Send a POST request to /prepare with the following JSON content (with the empty strings containing the actual values):

```json
{
    "data": {
        "sessionId": "",
        "language": "inform7",
        "compilerVersion": "",
        "uuid": ""
    },
    "included": [
        {
            "type": "file",
            "attributes": {
                "name": "story.ni",
                "directory": "Source",
                "contents": ""
            }
        }
    ]
}
```

Session id is used to identify identical projects so that when someone compiles the same project multiple times, the service can overwrite the previous version and save storage space. 

The session id should only contain letters A-Z (upper or lower case), numbers, and/or hyphens, and it should be at most 100 characters long. The id should be unique for each project so that users don't overwrite each others' work, but the same throughout the session. It should also be random enough that two different users won't ever use the same session id (don't use just a timestamp, for example.) It doesn't need to be stay the same forever though, for example it's ok to regenerate the id every time the user opens the project in the client.

Language should always be "inform7".

UUID is the project's UUID/IFID, which *should* stay the same throughout the project's lifetime. See the [IFWiki article on IFIDs](https://www.ifwiki.org/IFID) for details.

The "included" part should always look the same as in the example above, except for `included[0].attributes.contents` which should contain the game's source text. The service doesn't handle custom extensions or material files yet.

The service sets up the project for compilation and returns a JSON response that contains the job id:

```json
{
    "data": {
        "attributes": {
            "jobId": ""
        }
    }
}
```

The job id is used in the later stages to identify the project. Note that the job id is based on the session ID but they should not be expected to always be the same.

If there's an error, the service returns the error message instead:

```json
{
    "error": ""
}
```


### 2. Compiling

After the project has been prepared, the compilation process starts by calling `/compile/:compilerVersion/:jobId/:variant` where `:compilerVersion` is the same compiler version as given in the preparation stage, `:jobId` is the job id returned from the preparation request, and `:variant` is either `debug` or `release`.

The service starts the compilation and streams the compiler output as a response to the request.

JavaScript example for starting compilation and reading the compilation stream, using [Axios](https://axios-http.com):

```js
let compilerOutput = "";

await axios({
    method: "get",
    url: `http://example.com/compile/10.1.0/putJobIdHere/debug`,
    onDownloadProgress: event => {
        // get part of the response
        const text = event.currentTarget.responseText;

        // do something with it
        compilerOutput += text;

        console.log( "Chunk received from compiler:", text );
    }
});

console.log( "Full compiler output:", compilerOutput );
```


### 3. Checking results

After the compilation has finished, the results can be fetched from `/results/:jobId` where `:jobId` is again the same job id as earlier. The response JSON is:

```json
{
    "data": {
        "report": "",
        "success": true     // or false
    },
    "links": {
        "index": "",
        "storyfile": ""
    }
}
```

`data.success` is either `true` or `false` depending on the result of the compilation. `data.report` is a HTML string that has the compiler's report that either says that the compilation succeeded, or the error message if something went wrong.

`links.storyfile` is a URL to the resulting story file and `links.index` is the root URL to the generated index HTML pages. If the compilation failed, the `links` object is empty.


### 4. Downloading results

If compilation was successful, the links retrieved in the previous stage point to the URLs where the results can be downloaded. The index URL is the root directory which doesn't work by itself, but the required index page should be appended to it. The "front page" is `Contents.html` for compiler version 6G60 and `Welcome.html` for everything else. Those pages contain internal links that let the user navigate inside the index.

For example, if the response of the results check request is stored in a variable called `results` then the first index page is at `results.links.index + "Welcome.html"` (or `+ "Contents.html"` for 6G60.) The index URL contains a leading `/` character so it doesn't need to be added in between.

The results will be removed after a while with the included cron jobs (see below.) Naturally the links to results stop working after the files have been deleted, so they should be considered temporary.


## Cleanup cron jobs

The `cron` directory contains cron schedules that clean up old build files. At midnight UTC they'll check the file creation dates and delete everything that's older than one day.

Any files with a .cron file extension that are placed in the cron directory are installed as cron jobs in production. Cron logs are stored in /var/log/cron.log inside the Docker container.

The cron jobs aren't installed in the development environment. The project files can be deleted manually from volume/Stash and volume/Projects.


## Monitoring endpoints

These can be used to check the status and health of the service.


### /monitoring/ping

Responds with the text "pong".


### /monitoring/storage

If the server's storage space is running low, this endpoint returns a HTTP 500 answer. An external monitoring service can be set up to call this endpoint to check that the server isn't running out of disk space. 

The treshold is defined as a percentage in the STORAGE_ALERT_TRESHOLD environment variable. For example if `STORAGE_ALERT_TRESHOLD=90` then this returns HTTP 500 if the server's disk space is 90% or more full. If the variable isn't set, the treshold is set to 99.


## Sentry

The web service sets up [Sentry](https://sentry.io) error monitoring if the SENTRY_DSN environment variable is set and contains the [Sentry DSN key](https://docs.sentry.io/product/sentry-basics/dsn-explainer/). Leaving the variable empty disables Sentry.
