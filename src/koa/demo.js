const Koa = require('koa')
const route = require('koa-route')
const serve = require('koa-static')
const compose = require('koa-compose')
const koaBody = require('koa-body')
const fs = require('fs')
const os = require('os')
const path = require('path')
const app = new Koa()

// 17. file upload
// curl --form upload=@/path/to/file http://127.0.0.1:3000
// app.use(koaBody({ multipart: true }))
// app.use(async ctx => {
//   const tmpdir = os.tmpdir()
//   const filePaths = []
//   const files = ctx.request.body.files || {}
//   console.log(files)
//   for (let key in files) {
//     const file = files[key]
//     const filePath = path.join(tmpdir, file.name)
//     const reader = fs.createReadStream(file)
//     const writer = fs.createWriteStream(filePath)
//     reader.pie(writer)
//     filePaths.push(filePath)
//   }

//   ctx.body = filePaths
// })

// 16. form
// curl -X POST --data "name=Jack" 127.0.0.1:3000
// app.use(koaBody())
// app.use(ctx => {
//   const body = ctx.request.body
//   if (!body.name) {
//     ctx.throw(400, '.name required')
//   }
//   ctx.body = { name: body.name }
// })

// 15. cookies
// app.use(ctx => {
//   const count = Number(ctx.cookies.get('count') || 0) + 1
//   ctx.cookies.set('count', count)
//   ctx.response.body = count + ' views'
// })

// 14.emit error
// app.use(async (ctx, next) => {
//   try {
//     await next()
//   } catch (e) {
//     ctx.response.status = e.statusCode || e.status || 500
//     ctx.response.type = 'html'
//     ctx.response.body = '<p>Something wrong, please contact administrator.</p>'
//     ctx.app.emit('error', e, ctx)
//   }
// })

// 13.error listener
// app.on('error', (err, ctx) => {
//   console.error('server error', err)
// })

// 12.error middleware
// app.use(async (ctx, next) => {
//   try {
//     await next()
//   } catch (e) {
//     ctx.response.status = e.statusCode || e.status || 500
//     ctx.response.body = {
//       message: e.message
//     }
//   }
// })

// 11. 404 Not Fund
// app.use(ctx => {
//   ctx.response.status = 404
//   ctx.response.body = 'page not fund'
// })

// 10. 500 Error
// app.use(ctx => {
//   ctx.throw(500)
// })

// 09.compose middleware
// app.use(compose([(ctx, next) => {
//   console.log(`%s %s %s`, Date.now(), ctx.request.method, ctx.request.url)
//   next()
// }, async (ctx, next) => {
//   ctx.response.type = 'html'
//   ctx.response.body = await fs.createReadStream('./pages/index.html')
//   next()
// }]))

// 08.async middleware
// app.use(async ctx => {
//   ctx.response.type = 'html'
//   ctx.response.body = await fs.createReadStream('./pages/index.html')
// })

// 07.middleware stack
// app.use((ctx, next) => {
//   console.log('>> one')
//   next()
//   console.log('<< one')
// })
// app.use((ctx, next) => {
//   console.log('>> two')
//   next()
//   console.log('<< two')
// })
// app.use((ctx, next) => {
//   console.log('>> three')
//   next()
//   console.log('<< three')
// })


// // 06.middleware
// app.use((ctx, next) => {
//   console.log(`%s %s %s`, Date.now(), ctx.request.method, ctx.request.url)
//   next()
// })

// 05.redirect
// app.use(route.get('/redirect', ctx => {
//   ctx.response.redirect('/')
// }))

// 04.static
// app.use(serve(path.join(__dirname)))

// 03.route
// app.use(route.get('/', ctx => {
//   ctx.response.type = 'html'
//   ctx.response.body = '<h1>index</h1></h1><a href="/hello">say hello</a>'
// }))
// app.use(route.get('/hello', ctx => {
//   ctx.response.type = 'html'
//   ctx.response.body = fs.createReadStream('./pages/index.html')
// }))


// 01.response.body
// app.use(ctx => {
//   if (ctx.request.accepts('xml')) {
//     ctx.response.type = 'xml'
//     ctx.response.body = '<data>Hello World</data>'
//   } else if (ctx.request.accepts('html')) {
//     ctx.response.body = '<h1>hello world</h1>'
//   }
// })

// 02.path
// app.use(ctx => {
//   ctx.response.type = 'html'
//   if (ctx.request.path !== '/') {
//     ctx.response.body = fs.createReadStream('./pages/index.html')
//   } else {
//     ctx.response.body = '<h1>index</h1></h1><a href="/hello">say hello</a>'
//   }
// })


app.listen(3000)
