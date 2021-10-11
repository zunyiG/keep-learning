const websockify = require('koa-websocket');
const Koa = require('koa');
const route = require('koa-route')

const app = websockify(new Koa())

let ctxs = [];


app.ws.use((ctx, next) => {
  /* 每打开一个连接就往 上线文数组中 添加一个上下文 */
  ctxs.push(ctx);
  ctx.websocket.on("message", (message) => {
      console.log(message);
      for(let i = 0; i < ctxs.length; i++) {
          if (ctx == ctxs[i]) continue;
          ctxs[i].websocket.send(message);
      }
  });
  ctx.websocket.on("close", (message) => {
      /* 连接关闭时, 清理 上下文数组, 防止报错 */
      let index = ctxs.indexOf(ctx);
      ctxs.splice(index, 1);
  });
});

app.listen(9000);
