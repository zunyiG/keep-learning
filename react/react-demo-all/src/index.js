import React from 'react'
import ReactDOM from 'react-dom'
import { AppContainer } from 'react-hot-loader'
import { Provider } from 'react-redux'

import AppRouter from '_router/router'
import store from './redux/store'

let Router = AppRouter()

const render = Compoents => ReactDOM.render(
  <AppContainer>
    <Provider store={ store }>
      <Compoents/>
    </Provider>
  </AppContainer>,
  document.getElementById('app')
)

render(Router)

if (module.hot) {
   module.hot.accept('_router/router', _ => {
     render(Router)
   })
 }
