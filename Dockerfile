FROM mcr.microsoft.com/playwright:v1.52.0-noble
RUN npm install -g netlify-cli node-jq
RUN rm -rf  /root/.npm/_logs/2025-06-04T09_20_32_659Z-debug-0.log
RUN rm -rf node_modules/serve
RUN npm cache clean --force
RUN npm install node_modules/serve
RUN npm install -D @playwright/test@1.52.0
RUN npx playwright install