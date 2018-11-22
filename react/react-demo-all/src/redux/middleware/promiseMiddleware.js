import axios from 'axios'

export default store => next => action => {
  const { dispatch, getState } = store

  if (typeof action === 'function') {
    action(dispatch, getState)
    return
  }

  const {
    promise,
    types,
    afterSuccess,
    ...rest
  } = action

  if (!action.promise) {
    return next(action)
  }

  const [ REQUEST, SUCCESS, FAILURE ] = types

  next({
    ...rest,
    type: REQUEST
  })

  const onFulfilled = res => {
    next({
      ...rest,
      res,
      type: SUCCESS
    })
    afterSuccess && afterSuccess(dispatch, getState, res)
  }

  const onRejected = err => next({
    ...rest,
    err,
    type: FAILURE
  })

  return promise(axios)
    .then(onFulfilled, onRejected)
    .catch(err => {
      console.error('MIDDLEWARE ERROR', err)
      onRejected(err)
    })
}
