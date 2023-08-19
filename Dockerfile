FROM node:18-alpine AS deps
WORKDIR /app
COPY package.json yarn.lock ./
ENV PATH /app/node_modules/.bin:$PATH
RUN yarn config set network-timeout 600000 -g && yarn install --immutable --immutable-cache

FROM node:18-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN yarn build

FROM node:18-alpine AS runner
WORKDIR /app

ENV NODE_ENV production
ARG APP_KEYS=$APP_KEYS
ARG API_TOKEN_SALT=$API_TOKEN_SALT
ARG ADMIN_JWT_SECRET=$ADMIN_JWT_SECRET
ARG TRANSFER_TOKEN_SALT=$TRANSFER_TOKEN_SALT
ARG JWT_SECRET=$JWT_SECRET
ARG DATABASE_CLIENT=$DATABASE_CLIENT
ARG DATABASE_HOST=$DATABASE_HOST
ARG DATABASE_PORT=$DATABASE_PORT
ARG DATABASE_NAME=$DATABASE_NAME
ARG DATABASE_USERNAME=$DATABASE_USERNAME
ARG DATABASE_PASSWORD=$DATABASE_PASSWORD
ARG CLOUDINARY_NAME=$CLOUDINARY_NAME
ARG CLOUDINARY_KEY=$CLOUDINARY_KEY
ARG CLOUDINARY_SECRET=$CLOUDINARY_SECRET

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder --chown=nextjs:nodejs /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/favicon.png ./favicon.png
COPY --from=builder /app/.strapi-updater.json ./.strapi-updater.json
COPY --from=builder /app/public ./public

USER nextjs

EXPOSE 1337

ENV PORT 1337

CMD ["yarn", "start"]
