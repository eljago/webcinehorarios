import React from 'react';
import ReactOnRails from 'react-on-rails';

import Shows from '../containers/Shows';
import ShowEdit from '../containers/ShowEdit';


const ShowsApp = (props) => (
  <Shows {...props} />
)

const ShowEditApp = (props) => (
  <ShowEdit {...props} />
)

// This is how react_on_rails can see the HelloWorldApp in the browser.
ReactOnRails.register({ ShowsApp });

ReactOnRails.register({ ShowEditApp });