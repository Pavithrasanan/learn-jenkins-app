FROM mcr.microsoft.com/playwright:v1.52.0-noble
RUN npm install -g netlify-cli node-jq
RUN npm install -g serve
RUN npm install -g @playwright/test@1.52.0
RUN npx playwright install