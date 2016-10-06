import React from 'react';
import ReactOnRails from 'react-on-rails';

import Functions from '../containers/Functions';
import FunctionEdit from '../containers/FunctionEdit';

ReactOnRails.register({
  FunctionEditApp: (props) => (<FunctionEdit {...props} />),
  FunctionsApp: (props) => (<Functions {...props} />),
});