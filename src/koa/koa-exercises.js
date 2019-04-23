const Koa = require('koa')
const route = require('koa-route')
const session = require('koa-session')
const koaBody = require('koa-body')
var views = require('co-views')

const fs = require('fs')

const app = new Koa()
app.listen(process.argv[2] || 3000)
// 01
// app.use((ctx, next) => {
//   ctx.response.body = 'hello koa'
//   next()
// })

// 02
// app.use(async (ctx, next) => {
//   if(ctx.request.path !== '/') return await next()
//   ctx.response.body = 'hello koa'
// })

// app.use(async (ctx, next) => {
//   if(ctx.request.path !== '/404') return await next()
//   ctx.response.body = 'page not found'
// })

// app.use(async (ctx, next) => {
//   if(ctx.request.path !== '/500') return await next()
//   ctx.response.body = 'internal server error'
// })

// 02-2
// app.use(route.get('/', ctx => {
//   ctx.body = 'hello koa'
// }))

// app.use(route.get('/404', ctx => {
//   ctx.body = 'page not found'
// }))

// app.use(route.get('/500', ctx => {
//   ctx.body = 'internal server error'
// }))

// 03
// app.use(koaBody())
// app.use(route.post('/', ctx => {
//   ctx.body = String.prototype.toUpperCase.call(ctx.request.body.name)
// }))

// 04
// app.use(route.get('/stream', ctx => {
//   ctx.body = fs.createReadStream(process.argv[3])
// }))
// app.use(route.get('/json', ctx => {
//   ctx.body = { foo: 'bar' }
// }))

// 05
// app.use(route.all('/', ctx => {
//   if(ctx.is('application/json')) {
//     ctx.set('Content-Type', 'application/json')
//     ctx.body = {message: 'hi!'}
//   } else {
//     ctx.body = 'ok'
//   }
//   // or 
//   // ctx.body = ctx.is('application/json') ? {message: 'hi!'} : 'ok'
// }))

// 06
// app.use(responseTime)
// app.use(upperCase)
// app.use((ctx, next) => {
//   ctx.body = 'hello koa'
//   next()
// })

// async function responseTime (ctx, next) {
//   const start = Date.now()
//   await next()
//   ctx.set('X-Response-Time', Date.now() - start)
// }

// async function upperCase (ctx, next) {
//   await next()
//   ctx.body = String.prototype.toUpperCase.call(ctx.body)
// }

// 07
// app.use(errorHandler)

// app.use(ctx => {
//   if (ctx.path === '/error') throw new Error('ooops')
//   ctx.body = 'OK'
// })

// async function errorHandler(ctx, next) {
//   try {
//     await next()
//   } catch (err) {
//     ctx.status = err.statusCode || err.status || 500
//     ctx.body = 'internal server error'
//     // throw err
//   }
// }

// app.on('error', (err, ctx) => {
//   console.log(ctx.body)
// })

// 08
// app.keys = ['secret', 'keys']
// app.use(ctx => {
//   const times = ~~ctx.cookies.get('view', { signed: true }) + 1
//   ctx.cookies.set('view', times, {signed: true})
//   ctx.body = `${times} views`
// })

// 09
// app.keys = ['secret', 'keys']
// const CONFIG = {
//   key: 'koa:sess', /** (string) cookie key (default is koa:sess) */
//   /** (number || 'session') maxAge in ms (default is 1 days) */
//   /** 'session' will result in a cookie that expires when session/browser is closed */
//   /** Warning: If a session cookie is stolen, this cookie will never expire */
//   maxAge: 86400000,
//   autoCommit: true, /** (boolean) automatically commit headers (default true) */
//   overwrite: true, /** (boolean) can overwrite or not (default true) */
//   httpOnly: true, /** (boolean) httpOnly or not (default true) */
//   signed: true, /** (boolean) signed or not (default true) */
//   rolling: false, /** (boolean) Force a session identifier cookie to be set on every response. The expiration is reset to the original maxAge, resetting the expiration countdown. (default is false) */
//   renew: false, /** (boolean) renew session when session is nearly expired, so we can always keep user logged in. (default is false)*/
// }
// app.use(session(CONFIG, app))
// app.use(ctx => {
//   const times = ~~ctx.session.view + 1
//   ctx.session.view = times
//   ctx.body = `${times} views`
// })


// 10
// const render = views(__dirname + '/views', {
//   ext: 'ejs'
// })
// const user = {
//   name: {
//     first: 'Tobi',
//     last: 'Holowaychuk'
//   },
//   species: 'ferret',
//   age: 3
// }

// app.use(async ctx => {
//   ctx.body = await render('user', {user})
// })


// 11

const form = '<form action="/login" method="POST">\
<input name="username" type="text" value="username">\
<input name="password" type="password" placeholder="The password is \'password\'">\
<button type="submit">Submit</button>\
</form>'

app.keys = ['secret1', 'secret2', 'secret3']
app.use(session(app))
app.use(koaBody())

app.use(route.get('/', async function home(ctx, next) {
  if (ctx.session.signed) {
    ctx.body = 'hello world'
  } else {
    ctx.status = 401
  }
}))

app.use(route.get('/login' , async function login(ctx, next) {
  ctx.body = form
}))

app.use(route.post('/login' , async function login(ctx, next) {
  const logined = ctx.request.body.username === 'username' &&
  ctx.request.body.password === 'password'
  if (logined) {
    ctx.session.signed = true
    ctx.response.redirect('/')
  } else {
    ctx.status = 400
  }
}))

app.use(route.get('/logout' , async function login(ctx, next) {
  ctx.session.signed = undefined
  ctx.response.redirect('/login')
}))
