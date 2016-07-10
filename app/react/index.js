import RWR from 'react-webpack-rails';
RWR.run();

import Admin from './components/admin';
RWR.registerComponent('Admin', Admin);