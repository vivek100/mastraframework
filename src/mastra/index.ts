import { Mastra } from '@mastra/core/mastra';
import { PinoLogger } from '@mastra/loggers';
import { weatherWorkflow } from './workflows';
import { weatherAgent } from './agents';
import { LibSQLStore } from "@mastra/libsql";

export const mastra = new Mastra({
  workflows: { weatherWorkflow },
  agents: { weatherAgent },
  logger: new PinoLogger({
    name: 'Mastra',
    level: 'info',
  }),
  storage: new LibSQLStore({
      url: "file:../../memory.db",
    }),
    server: {
      server: {
        port: 3000,        // <-- match Freestyle's default health-check
        host: "0.0.0.0",   // <-- bind broadly so the VM and proxy can reach it
      },
    cors: {
      origin: ["http://localhost:3000"],  // allow the exact frontend origin
      allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
      allowHeaders: ["Content-Type", "Authorization"],
      credentials: true,                  // enable cookies/auth
    },
  },
});
