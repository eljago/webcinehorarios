'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';

import CinemaForm from '../components/CinemaForm'

import {CinemasQueries} from '../../../lib/api/queries'

export default class CinemaEdit extends React.Component {

  static propTypes = {
    cinema: PropTypes.object
  };

  constructor(props) {
    super(props);
  }

  render() {
    return (
      <CinemaForm
        cinema={this.props.cinema}
        
      />
    );
  }
}
