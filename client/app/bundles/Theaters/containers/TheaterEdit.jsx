'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';

import TheaterForm from '../components/TheaterForm'

import {TheatersQueries} from '../../../lib/api/queries'

export default class TheaterEdit extends React.Component {

  static propTypes = {
    theater: PropTypes.object
  };

  constructor(props) {
    super(props);
    this.state = {
      errors: []
    }
    _.bindAll(this, '_onSubmit');
  }

  render() {
    return (
      <TheaterForm
        errors={this.state.errors}
        theater={this.props.theater}
        onSubmit={this._onSubmit}
      />
    );
  }

  _onSubmit(theaterToSubmit, callback) {
    TheatersQueries.submitTheater({
      theater: theaterToSubmit
    },(response) => {
      callback(true);
    }, (errors) => {
      callback(false);
      console.log(errors);
      this.setState({errors: errors.error});
    })
  }
}
