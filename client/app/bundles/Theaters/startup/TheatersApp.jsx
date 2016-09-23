import React from 'react';
import ReactOnRails from 'react-on-rails';

import TheaterEdit from '../containers/TheaterEdit';

const TheaterEditApp = (props) => (
  <TheaterEdit {...props} />
)

// This is how react_on_rails can see the HelloWorldApp in the browser.
ReactOnRails.register({
  TheaterEditApp: TheaterEditApp
});