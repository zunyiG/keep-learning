import React, { Component } from 'react'
import { connect } from 'react-redux'

import { getUserInfo } from '_actions/userInfo'

import imgSrc from '_public/user1.jpg'

class UserInfo extends Component {
  render() {
    const { userInfo, isLoading, errMsg } = this.props.userInfo
    console.log(this.props.userInfo)
    return (
      <div>
        { isLoading ? 'Is loading ...'
          : (
            errMsg ? errMsg
              :
              <div>
                <h2>user info</h2>
                <img src={ imgSrc }></img>
                <ul>
                  <li>Name: { userInfo.name }</li>
                  <li>Age: { userInfo.age }</li>
                  <li>Like: { userInfo.like }</li>
                  <li>Gender: { userInfo.gender }</li>
                </ul>
              </div>
          )
        }
        <button onClick={ _ => this.props.getUserInfo() }>View user infomation</button>
      </div>
    )
  }
}

const mapStateToProps = ({ userInfo }) => ({ userInfo })

const mapDispatchToProps = { getUserInfo }


export default connect(mapStateToProps, mapDispatchToProps)(UserInfo)
