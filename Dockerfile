FROM mcr.microsoft.com/playwright:v1.39.0-noble
RUN npm install -g netlify-cli node-jq
RUN npm install -g serve
RUN npm install -g @playwright/test@v1.39.0-noble
RUN npx playwright install