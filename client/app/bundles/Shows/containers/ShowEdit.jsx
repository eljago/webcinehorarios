'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import ShowForm from '../components/ShowForm'

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
    _.bindAll(this, '_handleSubmit');
  }

  render() {
    return (
      <ShowForm
        show={this.props.show}
        genres={this.props.genres}
        videoTypes={this.props.videoTypes}
        onSubmit={this._handleSubmit}
        submitting={this.state.submitting}
        errors={this.state.errors}
        getShowPersonRolesOptions={this._getShowPersonRolesOptions}
      />
    );
  }

  _handleSubmit(showToSubmit) {
    console.log(showToSubmit);
    if (_.isEmpty(showToSubmit)) {
      this.setState({
        errors: {Error: ['Show Vacío']}
      });
      window.scrollTo(0, 0);
      return;
    }

    this.setState({submitting: true});
    const submitData = this.props.show.id ? 
      {
        url: `/api/shows/${this.props.show.id}`,
        type: 'PUT',
        data: {
          shows: {
            id: this.props.show.id,
            ...showToSubmit
          }
        }
      } :
      {
        url: '/api/shows',
        type: 'POST',
        data: {
          shows: {
            ...showToSubmit
          }
        }
      };

    $.ajax({
      ...submitData,
      success: (response) => {
        window.location.replace('/admin/shows');

      },
      error: (error) => {
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
            errors: {
              Error: [
                'ERROR 500'
              ]
            },
            submitting: false
          });
          window.scrollTo(0, 0);
        }
      }
    });
  }

  _getShowPersonRolesOptions(input, callback) {
    if (_.trim(input).length > 2) {
      $.getJSON(`/api/people/select_people?input=${input}`, (response) => {
        callback(null, {
          options: response.people
        });
      });
    }
    else {
      callback(null, {options: []});
    }
  }
}
