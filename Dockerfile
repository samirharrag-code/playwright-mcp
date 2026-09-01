ARG PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

FROM node:22-bookworm-slim

ARG PLAYWRIGHT_BROWSERS_PATH
ARG USERNAME=node

ENV PLAYWRIGHT_BROWSERS_PATH=${PLAYWRIGHT_BROWSERS_PATH}
ENV NODE_ENV=production

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --omit=dev && \
    npx -y playwright-core install-deps chromium && \
    npx -y playwright-core install --no-shell chromium

COPY cli.js package.json ./

RUN chown -R ${USERNAME}:${USERNAME} /app ${PLAYWRIGHT_BROWSERS_PATH}

USER ${USERNAME}

WORKDIR /home/${USERNAME}

CMD ["sh", "-c", "exec node /app/cli.js --headless --browser chromium --no-sandbox --port ${PORT:-8931} --host 0.0.0.0 --allowed-hosts '*'"]
