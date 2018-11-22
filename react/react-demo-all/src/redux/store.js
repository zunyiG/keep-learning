import { createStore, applyMiddleware } from 'redux'
// import thunkMiddleware from 'redux-thunk'

import combineReducers from './reducers'
import promiseMiddleware from './middleware/promiseMiddleware.js'

export default createStore(combineReducers, applyMiddleware(promiseMiddleware))
