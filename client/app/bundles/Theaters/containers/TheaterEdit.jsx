'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';
import update from 'react/lib/update';

import TheaterForm from '../components/TheaterForm'

import {TheatersQueries} from '../../../lib/api/queries'

import FormBuilder from '../../../lib/forms/FormBuilder';
import GetFormSchema from '../data/FormSchema'

export default class TheaterEdit extends React.Component {

  static propTypes = {
    theater: PropTypes.object
  };

  constructor(props) {
    super(props);
    this.state = {
      errors: {},
      submitting: false
    }
    _.bindAll(this, ['_onSubmit', '_onDelete']);
    this.formBuilder = new FormBuilder(
      GetFormSchema({
        onDelete: this._onDelete,
        onSubmit: this._onSubmit
      }),
      props.theater
    );
  }

  render() {
    return (
      <TheaterForm
        ref='form'
        formBuilder={this.formBuilder}
        errors={this.state.errors}
        submitting={this.state.submitting}
        theater={this.props.theater}
        onSubmit={this._onSubmit}
      />
    );
  }

  _onSubmit() {
    let submitOptions = this.refs.form.getResult();
    const success = (response) => {
      window.location.assign('/admin/cinemas');
    };
    const error = (errors) => {
      this.setState({
        errors: errors,
        submitting: false,
      });
    };
    this.setState({
      submitting: true
    });
    if (this.formBuilder.object.id) {
      TheatersQueries.submitEditTheater({
        theater: update(submitOptions, {id: {$set: this.formBuilder.object.id}}),
        success: success,
        error: error
      });
    }
    else {
      TheatersQueries.submitNewTheater({
        theater: submitOptions,
        success: success,
        error: error
      });
    }
  }

  _onDelete() {
    this.setState({submitting: true});
    TheatersQueries.submitDeleteTheater({
      theaterId: this.formBuilder.object.id,
      success: (response) => {
        window.location.assign('/admin/cinemas');
      },
      error: (errors) => {
        this.setState({
          errors: errors,
          submitting: false,
        });
      }
    });
  }
}
