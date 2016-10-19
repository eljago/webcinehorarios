import React from 'react';
import ReactOnRails from 'react-on-rails';

import Functions from '../containers/Functions';

ReactOnRails.register({
  FunctionsApp: (props) => (<Functions {...props} />),
});