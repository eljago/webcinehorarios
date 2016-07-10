import React from 'react'
import Dashboard from './Dashboard'
import NavBar from './NavBar'

export default class Main extends React.Component {

	constructor(props){
		super(props)
		this.state = {
			currentPage: 'dashboard'
		}
	}

  render() {
    return(
    	<div>
    		<NavBar />
    		<div className="container">
	    		<Dashboard />
	    	</div>
    	</div>
    );
  }
}

