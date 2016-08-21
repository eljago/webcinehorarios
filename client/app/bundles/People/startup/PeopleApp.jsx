import React from 'react';
import ReactOnRails from 'react-on-rails';

import People from '../containers/People';
// import ShowEdit from '../containers/ShowEdit';

ReactOnRails.setOptions({
  traceTurbolinks: TRACE_TURBOLINKS,
});

// This is how react_on_rails can see the HelloWorldApp in the browser.
ReactOnRails.register({
  PeopleApp: (props) => (<People {...props} />),
  // ShowEditApp: (props) => (<ShowEdit {...props} />),
});