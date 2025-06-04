FROM mcr.microsoft.com/playwright:v1.52.0-noble
RUN npm install -g netlify-cli node-jq
RUN npm install serve
RUn npm install -D @playwright/test@1.52.0
RUN npx playwright install