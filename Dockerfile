FROM mcr.microsoft.com/playwright:v1.52.0-jammy
RUN npm install -g netlify-cli node-jq serve @playwright/test@1.52.0
RUN npx playwright install
RUN apt update && apt install jq -y