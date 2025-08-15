FROM node:12.3

COPY . .

RUN npm install

EXPOSE 3000

# 環境変数のデフォルト値を設定
ENV PORT=3000

CMD [ "node", "main.js" ]
