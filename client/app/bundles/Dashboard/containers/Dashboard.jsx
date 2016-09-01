'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';
import DashboardMain from '../components/DashboardMain';

export default class Dashboard extends React.Component {

  static propTypes = {
    cinemas: PropTypes.array
  };

  render() {
    return (
      <DashboardMain
        cinemas={this.props.cinemas}
      />
    );
  }
}
