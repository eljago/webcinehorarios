import React from 'react';
import ReactOnRails from 'react-on-rails';

import Cinemas from '../containers/Cinemas';
import CinemaEdit from '../containers/CinemaEdit';

const CinemasApp = (props) => (
  <Cinemas {...props} />
)

const CinemaEditApp = (props) => (
  <CinemaEdit {...props} />
)

// This is how react_on_rails can see the HelloWorldApp in the browser.
ReactOnRails.register({
  CinemasApp: CinemasApp,
  CinemaEditApp: CinemaEditApp
});