# 使用 node 官方映像檔建立前端靜態檔案
FROM node:20-alpine AS build
WORKDIR /app
COPY . .
RUN npm install && npm run build

# 使用輕量 nginx 供靜態檔案服務
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html

# 讀取 PORT 環境變數並改寫 nginx 監聽設定
ENV PORT=8080
RUN sed -i 's/listen 80;/listen ${PORT};/' /etc/nginx/conf.d/default.conf

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]