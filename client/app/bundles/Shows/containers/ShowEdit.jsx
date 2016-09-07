'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import ShowForm from '../components/ShowForm'

import {ShowsQueries, SelectQueries} from '../../../lib/api/queries'

export default class ShowEdit extends React.Component {
  static propTypes = {
    show: PropTypes.object,
    genres: PropTypes.array,
    videoTypes: PropTypes.array,
  };

  constructor(props) {
    super(props);
    this.state = {
      submitting: false,
      errors: {}
    };
    _.bindAll(this, ['_handleSubmit', '_onDelete']);
  }

  render() {
    return (
      <ShowForm
        show={this.props.show}
        genres={this.props.genres}
        videoTypes={this.props.videoTypes}
        onSubmit={this._handleSubmit}
        onDeleteShow={this._onDelete}
        submitting={this.state.submitting}
        errors={this.state.errors}
        getShowPersonRolesOptions={this._getShowPersonRolesOptions}
      />
    );
  }

  _handleSubmit(showToSubmit) {
    console.log(showToSubmit);
    if (_.isEmpty(showToSubmit)) {
      window.location.assign('/admin/shows');
      return;
    }

    const success = (response) => {
      window.location.assign('/admin/shows');
    };
    const error = (error) => {
      // Rails validations failed
      if (error.status == 422) {
        console.log(error.responseJSON.errors);
        this.setState({
          errors: !_.isEmpty(error.responseJSON.errors) ? error.responseJSON.errors : {},
          submitting: false
        });
        window.scrollTo(0, 0);
      }
      else if (error.status == 500) {
        console.log(error.statusText);
        this.setState({
          errors: {Error: ['ERROR 500']},
          submitting: false
        });
        window.scrollTo(0, 0);
      }
    }

    this.setState({submitting: true});
    if (this.props.show.id) {
      ShowsQueries.submitEditShow({
        show: {
          id: this.props.show.id,
          ...showToSubmit
        }
      }, success, error);
    }
    else {
      ShowsQueries.submitNewShow({
        show: showToSubmit
      }, success, error);
    }
  }

  _getShowPersonRolesOptions(input, callback) {
    if (_.trim(input).length > 2) {
      SelectQueries.getPeople(input, (response) => {
        callback(null, {
          options: response.people
        });
      });
    }
    else {
      callback(null, {options: []});
    }
  }

  _onDelete(showId) {
    this.setState({
      loadingContent: true
    });
    ShowsQueries.submitDeleteShow({
      showId: showId
    }, (response) => {
      window.location.assign('/admin/shows');
      this.setState({
        loadingContent: false
      });
    }, (error) => {
      console.log(error);
    })
  }
}
