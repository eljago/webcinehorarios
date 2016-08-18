import React from 'react';
import ReactOnRails from 'react-on-rails';

import ParsedShows from '../containers/ParsedShows';

ReactOnRails.register({
  ParsedShowsApp: (props) => (<ParsedShows {...props} />)
});