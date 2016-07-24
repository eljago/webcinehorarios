import React from 'react';
import ReactOnRails from 'react-on-rails';

import NavBar from '../containers/NavBar';


const NavBarApp = (props) => (
  <NavBar {...props} />
)

// This is how react_on_rails can see the HelloWorldApp in the browser.
ReactOnRails.register({ NavBarApp });