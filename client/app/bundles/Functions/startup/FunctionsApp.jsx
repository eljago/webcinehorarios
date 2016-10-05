import React from 'react';
import ReactOnRails from 'react-on-rails';

import Functions from '../containers/Functions';

const FunctionEditApp = (props) => (
  <FunctionEdit {...props} />
)
const FunctionsApp = (props) => (
  <Functions {...props} />
)

// This is how react_on_rails can see the HelloWorldApp in the browser.
ReactOnRails.register({
  FunctionEditApp: FunctionEditApp,
  FunctionsApp: FunctionsApp
});