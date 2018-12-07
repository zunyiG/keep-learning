import React, { Component } from 'react'
import { increment, decrement, reset } from '_actions/counter'
import { connect } from 'react-redux'

class counter extends Component{
  render () {
    return (
      <div>
        <h2>count is { this.props.counter.count }</h2>
        <button
          onClick={ this.props.increment }
          >increment</button>
        <button
          onClick={ this.props.decrement }
          >decrement</button>
        <button
          onClick={ this.props.reset }
          >reset</button>
      </div>
    )
  }
}

const mapStateToProps = ({ counter }) => ({ counter })

const mapDispatchToProps = dispatch => ({
  increment: _ => dispatch(increment()),
  decrement: _ => dispatch(decrement()),
  reset: _ => dispatch(reset()),
})

export default connect(mapStateToProps, mapDispatchToProps)(counter)
