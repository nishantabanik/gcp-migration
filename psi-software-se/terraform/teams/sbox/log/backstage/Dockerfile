FROM node:20-bookworm-slim AS build-base

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends g++ build-essential libsqlite3-dev python3 python3-pip python3-venv && \
    yarn config set python /usr/bin/python3 && \
    python3 -m venv $VIRTUAL_ENV && \
    pip3 install mkdocs-techdocs-core


FROM node:20-bookworm-slim AS packages

COPY src/package.json src/yarn.lock /app/
COPY src/.yarn /app/.yarn
COPY src/.yarnrc.yml /app/
COPY src/backstage.json /app/
COPY src/packages /app/packages
RUN find /app/packages \! -name "package.json" -mindepth 2 -maxdepth 2 -exec rm -rf {} \+


FROM build-base AS build

USER node
WORKDIR /app
COPY --from=packages --chown=node:node /app .
COPY --from=packages --chown=node:node /app/.yarn ./.yarn
COPY --from=packages --chown=node:node /app/.yarnrc.yml  ./
COPY --from=packages --chown=node:node /app/backstage.json ./
RUN --mount=type=cache,target=/home/node/.cache/yarn,sharing=locked,uid=1000,gid=1000 \
    NODE_OPTIONS=--max-old-space-size=1024 yarn install --immutable
COPY --chown=node:node src/. .
COPY --chown=node:node packages/backend/src/index.ts ./packages/backend/src/index.ts
COPY --chown=node:node packages/app/src/App.tsx ./packages/app/src/App.tsx
COPY --chown=node:node packages/app/src/apis.ts ./packages/app/src/apis.ts
COPY --chown=node:node packages/app/src/components ./packages/app/src/components
RUN yarn --cwd src/packages/backend add @backstage/plugin-scaffolder-backend-module-gitlab@^0.7.0 && \
    yarn --cwd src/packages/backend add @backstage/plugin-catalog-backend-module-gitlab@^0.6.0 && \
    yarn --cwd src/packages/backend add @backstage-community/plugin-catalog-backend-module-keycloak && \
    yarn --cwd src/packages/app add @backstage/plugin-home@^0.8.4 && \
    yarn tsc && \
    yarn --cwd packages/backend build && \
    mkdir packages/backend/dist/skeleton packages/backend/dist/bundle && \
    tar xzf packages/backend/dist/skeleton.tar.gz -C packages/backend/dist/skeleton && \
    tar xzf packages/backend/dist/bundle.tar.gz -C packages/backend/dist/bundle

FROM build-base

ENV NODE_ENV=production
ENV NODE_OPTIONS="--no-node-snapshot"

USER node
WORKDIR /app
COPY --from=build --chown=node:node /app/.yarn ./.yarn
COPY --from=build --chown=node:node /app/.yarnrc.yml  ./
COPY --from=build --chown=node:node /app/backstage.json ./
COPY --from=build --chown=node:node /app/yarn.lock /app/package.json /app/packages/backend/dist/skeleton/ ./
RUN --mount=type=cache,target=/home/node/.cache/yarn,sharing=locked,uid=1000,gid=1000 \
    yarn workspaces focus --all --production && rm -rf "$(yarn cache clean)"

COPY --from=build --chown=node:node /app/packages/backend/dist/bundle/ ./
COPY --chown=node:node app-config*.yaml ./
COPY --chown=node:node ./org ./org
COPY --chown=node:node ./local-catalog ./local-catalog
COPY --chown=node:node ./template/ ./template/
COPY --chown=node:node ./techdocs/ ./techdocs/

CMD ["node", "packages/backend", "--config", "app-config.yaml", "--config", "app-config.ingress.yaml", "--config", "app-config.production.yaml"]
