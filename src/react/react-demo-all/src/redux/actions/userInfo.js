export const GET_USERINFO_REQUEST = "userinfo/GET_USERINFO_REQUEST"
export const GET_USERINFO_SUCCESS = "userinfo/GET_USERINFO_SUCCESS"
export const GET_USERINFO_FAIL = "userinfo/GET_USERINFO_FAIL"

export function getUserInfoRequest () {
  return { type: GET_USERINFO_REQUEST }
}

export function getUserInfoSuccess (userInfo) {
  return {
    type: GET_USERINFO_SUCCESS,
    userInfo
  }
}

export function getUserInfoFail () {
  return { type: GET_USERINFO_FAIL }
}

export function getUserInfo () {
  return {
    types: [GET_USERINFO_REQUEST, GET_USERINFO_SUCCESS, GET_USERINFO_FAIL],
    promise: client => client.get('/api/userinfo.json')
  }
}
