# Base image we are building from
FROM node:16-alpine as build

COPY . .

RUN yarn install --pure-lock-file --no-progress --non-interactives
RUN yarn build

# Downloads the dependencies required for Production
FROM node:16-alpine as dependencies

COPY . .

RUN yarn install --pure-lock-file --no-progress --non-interactives --production

# This step allows us to run the app in Production
FROM node:16-alpine as production

# Copy source and prod dependencies
COPY --from=build /build/ ./build
COPY --from=dependencies /node_modules ./node_modules

EXPOSE 8080

CMD ["node", "build/index.js"]