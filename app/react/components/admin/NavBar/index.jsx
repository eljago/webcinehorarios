import React from 'react'
import ReactDOM from 'react-dom'
import {Nav, Navbar, NavDropdown, MenuItem, NavItem} from 'react-bootstrap'

export default class NavBar extends React.Component {

	componentDidMount() {
    console.log('did mount')
    this._removeHref()
	}

	componentDidUpdate(prevProps, prevState) {
    console.log('did update')
    this._removeHref()
	}

  render() {
    console.log('render')
    return(
    	<Navbar inverse>
		    <Navbar.Header>
		      <Navbar.Brand>
		        <a href="#">React-Bootstrap</a>
		      </Navbar.Brand>
		      <Navbar.Toggle />
		    </Navbar.Header>
		    <Navbar.Collapse>
		      <Nav>
		        <NavItem eventKey={1} href="#">Link</NavItem>
		        <NavItem eventKey={2} href="#">Link</NavItem>
		        <NavDropdown onClick={this._removeHref.bind(this)} ref={'dropdown'} eventKey={3} title="Dropdown" id="basic-nav-dropdown">
		          <MenuItem eventKey={3.1}>Action</MenuItem>
		          <MenuItem eventKey={3.2}>Another action</MenuItem>
		          <MenuItem eventKey={3.3}>Something else here</MenuItem>
		          <MenuItem divider />
		          <MenuItem eventKey={3.3}>Separated link</MenuItem>
		        </NavDropdown>
		      </Nav>
		      <Nav pullRight>
		        <NavItem eventKey={1} href="#">Link Right</NavItem>
		        <NavItem eventKey={2} href="#">Link Right</NavItem>
		      </Nav>
		    </Navbar.Collapse>
		  </Navbar>
    )
  }

	_removeHref() {
    const dropdownLink = ReactDOM.findDOMNode(this.refs.dropdown).querySelector(".dropdown-toggle")
    dropdownLink.removeAttribute("href")
    console.log(dropdownLink);
	}
}

