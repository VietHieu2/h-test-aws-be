FROM node:20-alpine AS builder

WORKDIR /usr/src/app

COPY  --chown=node:node package*.json ./

RUN yarn install --frozen-lockfile

COPY --chown=node:node . .

RUN yarn build

ENV NODE_ENV production

RUN yarn install --production=true --frozen-lockfile

USER node

FROM node:20-alpine AS run

COPY --chown=node:node --from=builder /usr/src/app/node_modules ./node_modules
COPY --chown=node:node --from=builder /usr/src/app/dist ./dist
COPY --chown=node:node --from=builder /usr/src/app/package.json ./

CMD ["yarn", "start:prod"]