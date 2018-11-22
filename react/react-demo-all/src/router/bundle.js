import React, { Component } from 'react'

export default class Boundle extends Component {
  constructor (props) {
    super(props)
    this.state = {
      mod: null
    }
  }

  componentWillMount () {
    this.load(this.props)
  }

  componentWillReceiveProps (nextProps) {
    if (this.props.load !== nextProps.load) {
      this.load(nextProps)
    }
  }

  load (props) {
    this.setState({
      mod: null
    })

    props.load( mod => this.setState({
      mod: mod.default ? mod.default : mod
    }))
  }

  render () {
    return this.props.children(this.state.mod)
  }
}
