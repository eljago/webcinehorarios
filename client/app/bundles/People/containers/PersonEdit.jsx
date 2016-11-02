'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import update from 'react/lib/update';

import PersonForm from '../components/PersonForm'

import {PeopleQueries} from '../../../lib/api/queries'

import FormBuilder from '../../../lib/forms/FormBuilder';
import GetFormSchema from '../data/FormSchema'

export default class PersonEdit extends React.Component {

  static propTypes = {
    person: PropTypes.object,
    onClose: PropTypes.func,
    onSuccess: PropTypes.func,
  };

  constructor(props) {
    super(props);
    _.bindAll(this, [
      '_onSubmit',
      '_onDelete',
    ]);
    this.state = {
      errors: {},
      submitting: false,
      formBuilder: new FormBuilder(
        GetFormSchema({
          onDelete: this._onDelete,
          onSubmit: this._onSubmit
        }),
        props.person
      ),
    };
  }

  render() {
    return (
      <PersonForm
        ref='form'
        formBuilder={this.state.formBuilder}
        submitting={this.state.submitting}
        errors={this.state.errors}
        onClose={this.props.onClose}
      />
    );
  }

  _onSubmit() {
    let submitOptions = this.refs.form.getResult();
    const success = (response) => {
      this.props.onSuccess();
      this.setState({
        submitting: false,
      });
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
    if (this.state.formBuilder.object.id) {
      PeopleQueries.submitEditPerson({
        person: update(submitOptions, {id: {$set: this.state.formBuilder.object.id}}),
        success: success,
        error: error
      });
    }
    else {
      PeopleQueries.submitNewPerson({
        person: submitOptions,
        success: success,
        error: error
      });
    }
  }

  _onDelete() {
    this.setState({submitting: true});
    PeopleQueries.submitDeletePerson({
      personId: this.state.formBuilder.object.id,
      success: (response) => {
        this.props.onSuccess();
        this.setState({
          submitting: false,
        });
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
