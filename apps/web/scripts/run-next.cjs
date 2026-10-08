// Runs the Next.js CLI in this process with telemetry disabled.
// Setting the variable here, rather than through a Node.js option such as
// --env-file, keeps it out of process.execArgv, which Next.js forwards to its
// workers through NODE_OPTIONS.
process.env.NEXT_TELEMETRY_DISABLED = "1";
require("next/dist/bin/next");
