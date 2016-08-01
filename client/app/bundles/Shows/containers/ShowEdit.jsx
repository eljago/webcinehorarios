'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import ShowForm from '../components/ShowForm'

import FormBuilderShow from '../../../lib/forms/FormBuilders/FormBuilderShow'

export default class ShowEdit extends React.Component {
  static propTypes = {
    show: PropTypes.object,
    genres: PropTypes.array,
  };

  constructor(props) {
    super(props);
    this.state = {
      submitting: false,
      errors: {}
    };
    _.bindAll(this, '_handleSubmit');
    this.formBuilder = new FormBuilderShow(props.show, props.genres,
      this._getPeopleSelectOptions, this._getVideoTypesOptions);
  }

  render() {
    return (
      <ShowForm
        show={this.props.show}
        onSubmit={this._handleSubmit}
        submitting={this.state.submitting}
        formBuilder={this.formBuilder}
        errors={this.state.errors}
      />
    );
  }

  _handleSubmit(showToSubmit) {
    this.setState({submitting: true});

    $.ajax({
      url: `/api/shows/${this.props.show.id}`,
      type: 'PUT',
      data: {
        shows: {
          id: this.props.show.id,
          ...showToSubmit
        }
      },
      success: (response) => {
        // window.location.replace('/admin/shows');

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

  _getPeopleSelectOptions(input, callback) {
    if (_.trim(input).length > 2) {
      $.getJSON(`/api/people/select_people?input=${input}`, (response) => {
        callback(null, {
            options: response.people,
            complete: response.people.length >= 10
        });
      });
    }
    else {
      callback(null, {options: [], complete: false});
    }
  }

  _getVideoTypesOptions(input, callback) {
    $.getJSON('/api/videos/select_video_types', (response) => {
      callback(null, {
          options: response.video_types,
          complete: true
      });
    });
  }
}
