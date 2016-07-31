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
      canSubmit: true,
      errors: {}
    };
    _.bindAll(this, '_handleSubmit');
    this.formBuilder = new FormBuilderShow(props.show, props.genres, this._getPeopleSelectOptions);
  }

  render() {
    return (
      <ShowForm
        show={this.props.show}
        onSubmit={this._handleSubmit}
        canSubmit={this.state.canSubmit}
        formBuilder={this.formBuilder}
        errors={this.state.erros}
      />
    );
  }

  _handleSubmit(showToSubmit) {
    this.setState({canSubmit: false});
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
            errors: error.responseJSON.errors,
            canSubmit: true
          });
        }
        else if (error.status == 500) {
          console.log(error.statusText);
          this.setState({
            canSubmit: true
          });
        }
      }
    });
  }

  _getPeopleSelectOptions(input, callback) {
    if (_.trim(input).length > 3) {
      $.getJSON(`/api/people/select_people?input=${input}`, (response) => {
        callback(null, {
            options: response.people,
            // CAREFUL! Only set this to true when there are no more options,
            // or more specific queries will not be sent to the server.
            complete: true
        });
      });
    }
    else {
      callback(null, {options: [], complete: false});
    }
  }
}
