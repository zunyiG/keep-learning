import React, { Component } from 'react'
import './home.scss'

export default class Home extends Component {
  constructor (props) {
    super(props)
    this.state = {
      count: 0
    }
  }

  _test () {
    this.setState({
      count: this.state.count + 1
    })
  }

  render () {
    return (
      <div>
        <h1>Welcome !!!</h1>
        <p>This is home page.</p>
        <div className="wrap">
          <div className="content">
            <h4>click count { this.state.count }</h4>
            <button onClick={ _ => this._test() }>click me</button>
          </div>
        </div>
      </div>
    )
  }
}
