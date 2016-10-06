import React from 'react';
import ReactOnRails from 'react-on-rails';

import Shows from '../containers/Shows';
import ShowEdit from '../containers/ShowEdit';

ReactOnRails.setOptions({
  traceTurbolinks: TRACE_TURBOLINKS,
});

ReactOnRails.register({
  ShowsApp: (props) => (<Shows {...props} />),
  ShowEditApp: (props) => (<ShowEdit {...props} />),
});