import { openai } from '@ai-sdk/openai';
import { Agent } from '@mastra/core/agent';
import { weatherTool } from '../tools';

// @node {"id":"agent.weatherAgent","type":"agent","name":"Weather Agent"}
// @prop {"target":"node","id":"agent.weatherAgent","key":"model","ref":{"expr":"weatherAgent.model","file":"mvp0.02/mastraframework/src/mastra/agents/index.ts"},"editable":true}
// @prop {"target":"node","id":"agent.weatherAgent","key":"instructions","ref":{"expr":"weatherAgent.instructions","file":"mvp0.02/mastraframework/src/mastra/agents/index.ts"},"editable":true}
// @prop {"target":"node","id":"agent.weatherAgent","key":"tools","ref":{"expr":"weatherAgent.tools","file":"mvp0.02/mastraframework/src/mastra/agents/index.ts"}}
// @edge {"from":"agent.weatherAgent","to":"tool.weatherTool"}
// @prop {"target":"edge","id":"edge:agent.weatherAgent→tool.weatherTool#1","key":"label","value":"uses this","editable":true}
export const weatherAgent = new Agent({
  name: 'Weather Agent',
  instructions: `
      You are a helpful weather assistant that provides accurate weather information.

      Your primary function is to help users get weather details for specific locations. When responding:
      - Always ask for a location if none is provided
      - If the location name isn’t in English, please translate it
      - If giving a location with multiple parts (e.g. "New York, NY"), use the most relevant part (e.g. "New York")
      - Include relevant details like humidity, wind conditions, and precipitation
      - Keep responses concise but informative

      Use the weatherTool to fetch current weather data.
`,
  model: openai('gpt-4o'),
  tools: { weatherTool },
});
