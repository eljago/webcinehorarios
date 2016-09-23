'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import ShowForm from '../components/ShowForm'

import {ShowsQueries, SelectQueries} from '../../../lib/api/queries'

export default class ShowEdit extends React.Component {
  static propTypes = {
    defaultShowPersonRole: PropTypes.object,
    defaultVideo: PropTypes.object,
    defaultImage: PropTypes.object,
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
        defaultShowPersonRole={this.props.defaultShowPersonRole}
        defaultVideo={this.props.defaultVideo}
        defaultImage={this.props.defaultImage}
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

    const submitOptions = {
      show: showToSubmit,
      success: (response) => {
        window.location.assign('/admin/shows');
      },
      error: (errors) => {
        this.setState({
          errors: errors,
          submitting: false
        });
      }
    };

    this.setState({submitting: true});
    if (this.props.show.id) {
      ShowsQueries.submitEditShow(submitOptions);
    }
    else {
      ShowsQueries.submitNewShow(submitOptions);
    }
  }

  _getShowPersonRolesOptions(input, callback) {
    if (_.trim(input).length > 2) {
      SelectQueries.getPeople({
        input: input,
        success: (response) => {
          callback(null, {
            options: response.people
          });
        }
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
      showId: showId,
      success: (response) => {
        window.location.assign('/admin/shows');
        this.setState({
          loadingContent: false
        });
      },
      error: (error) => {
        console.log(error);
      }
    });
  }
}
