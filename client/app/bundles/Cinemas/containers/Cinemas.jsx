'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';
import CinemasMain from '../components/CinemasMain';

import {TheatersQueries} from '../../../lib/api/queries'

export default class Cinemas extends React.Component {

  static propTypes = {
    cinemas: PropTypes.array
  };

  constructor(props) {
    super(props);
    this.state = {
      selectedCinemaId: props.cinemas[0].id,
      theaters: [],
      loadingTheaters: false,
      errors: {},
    }
    _.bindAll(this, '_onClickCinema')
  }

  componentDidMount() {
    this._updateTheaters(this.state.selectedCinemaId);
  }

  render() {
    return (
      <CinemasMain
        cinemas={this.props.cinemas}
        theaters={this.state.theaters}
        selectedCinemaId={this.state.selectedCinemaId}
        onClickCinema={this._onClickCinema}
        loadingTheaters={this.state.loadingTheaters}
        errors={this.state.errors}
      />
    );
  }

  _updateTheaters(cinemaId) {
    this.setState({loadingTheaters: true});
    TheatersQueries.getTheaters({
      cinemaId: cinemaId,
      success: (response) => {
        this.setState({
          selectedCinemaId: cinemaId,
          theaters: response.theaters,
          loadingTheaters: false
        });
      },
      error: (errors) => {
        this.setState({
          selectedCinemaId: cinemaId,
          theaters: [],
          loadingTheaters: false,
          errors: errors,
        });
      }
    });
  }

  _onClickCinema(cinemaId) {
    if (this.state.selectedCinemaId != cinemaId) {
      this._updateTheaters(cinemaId);
    }
  }
}
