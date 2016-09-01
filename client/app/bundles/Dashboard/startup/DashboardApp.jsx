import React from 'react';
import ReactOnRails from 'react-on-rails';

import Dashboard from '../containers/Dashboard';


const DashboardApp = (props) => (
  <Dashboard {...props} />
)

// This is how react_on_rails can see the HelloWorldApp in the browser.
ReactOnRails.register({ DashboardApp });