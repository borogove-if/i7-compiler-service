import app from "./server/express";

// Start the server
const port = Number( process.env.PORT );

if( !port ) {
    throw new Error( "PORT environment variable missing" );
}

app.listen( port, () => {
    console.log( "Inform 7 compiler service started on port " + port );
});
