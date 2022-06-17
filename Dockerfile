FROM node:latest AS builder
WORKDIR /opt/vue
COPY package.json yarn.lock ./
RUN yarn
COPY ./ ./
RUN yarn build

FROM nginx:latest AS runtime
WORKDIR /usr/share/nginx/html/
COPY --from=builder /opt/vue/dist/ ./
