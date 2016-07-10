import RWR from 'react-webpack-rails';
RWR.run();

import HomeIndex from './components/admin/home';
RWR.registerComponent('HomeIndex', HomeIndex);

import NavBar from './components/admin/NavBar';
RWR.registerComponent('NavBar', NavBar);

import Example from './components/admin/home/Example';
RWR.registerComponent('Example', Example);