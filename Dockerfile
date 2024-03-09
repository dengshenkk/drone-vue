# 基于什么镜像
FROM node:lts-alpine

# 在容器中创建 app 目录
WORKDIR /app

# 安装项目依赖
COPY package*.json ./
RUN npm install

# 复制项目文件到容器中
COPY . .

# 构建项目
RUN npm run build

# 卸载开发依赖
RUN npm prune --production

# 以nginx作为基础镜像，将构建好的文件 serve 出来
FROM nginx:stable-alpine as production-stage

# 将刚刚构建出来的文件复制到nginx指定的 serve 目录下面
COPY --from=0 /app/dist /usr/share/nginx/html

# 对外暴露的端口
EXPOSE 80

# 当容器启动时执行的命令
CMD ["nginx", "-g", "daemon off;"]