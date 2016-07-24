'use strict';

import React, { PropTypes } from 'react';
import NavBarComponent from '../components/NavBarComponent';

// Simple example of a React "smart" component
export default class NavBar extends React.Component {
  static propTypes = {
    navBarItemsData: PropTypes.array.isRequired,
  };

  render() {
    return (
      <div>
        <NavBarComponent navBarItemsData={this.props.navBarItemsData} />
      </div>
    );
  }
}
