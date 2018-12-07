import React, { Component } from 'react'
import { BrowserRouter as Router, Route, Switch, Link } from 'react-router-dom'

import Home from 'bundle-loader?lazy&name=home!_pages/home/Home'
import About from 'bundle-loader?lazy&name=about!_pages/about/About'
import Counter from 'bundle-loader?lazy&name=counter!_pages/counter/Counter'
import UserInfo from 'bundle-loader?lazy&name=userInfo!_pages/user-info/UserInfo'
import Boundle from './bundle';

const Loading = _ => <div>Loading...</div>
const createComponent = component => props =>
  <Boundle load={ component }>
    {
      Compmt => Compmt ? <Compmt { ...props }/> : <Loading />
    }
  </Boundle>

const AppRouter = () => {
  return class extends Component {
    render () {
      return (
        <Router>
          <div>
            <nav>
            <ul>
              <li><Link to="/">Home</Link></li>
              <li><Link to="/about">About</Link></li>
              <li><Link to="/counter">Counter</Link></li>
              <li><Link to="/userInfo">UserInfo</Link></li>
            </ul>
            <Switch>
              <Route exact path="/" component={ createComponent(Home) }/>
              <Route path="/about" component={ createComponent(About) }/>
              <Route path="/counter" component={ createComponent(Counter) }/>
              <Route path="/userInfo" component={ createComponent(UserInfo) }/>
            </Switch>
            </nav>
          </div>
        </Router>
      )
    }
  }
}

export default AppRouter
