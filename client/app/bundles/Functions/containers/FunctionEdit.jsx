'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import update from 'react/lib/update';

import FunctionForm from '../components/FunctionForm'

import {FunctionsQueries} from '../../../lib/api/queries'

import FormBuilder from '../../../lib/forms/FormBuilder';
import GetFormSchema from '../data/FormSchema'

export default class FunctionEdit extends React.Component {
  static propTypes = {
    defaultFunction: PropTypes.object,
    shows: PropTypes.array,
    function_types: PropTypes.array,
  };

  constructor(props) {
    super(props);
    this.state = {
      formBuilders: props.shows.map((show, index) => {
        return new FormBuilder(
          GetFormSchema({
            function_types: props.function_types.map((ft) => {
              return {value: ft.id, label: ft.name};
            }),
            defaultFunction: props.defaultFunction
          }),
          show
        );
      }),
      submitting: false,
      errors: {},
    };
    _.bindAll(this, ['_handleSubmit', '_onDelete']);
  }

  render() {
    return (
      <FunctionForm
        ref='form'
        formBuilders={this.state.formBuilders}
        errors={this.state.errors}
        submitting={this.state.submitting}
      />
    );
  }

  _handleSubmit() {
    if (this.refs.form) {
      let functionToSubmit = this.refs.form.getResult();
      functionToSubmit.id = this.props.function.id;
      this.setState({submitting: true});
      FunctionsQueries.submitEditFunction({
        func: functionToSubmit,
        success: (response) => {
          window.location.assign(`/admin/theaters/${this.props.function.theater.slug}/functions`);
        },
        error: (errors) => {
          this.setState({
            errors: errors,
            submitting: false
          });
        }
      });
    }
  }

  _onDelete() {
    this.setState({
      submitting: true
    });
    FunctionsQueries.submitDeleteFunction({
      functionId: this.props.function.id,
      success: (response) => {
        window.location.assign(`/admin/theaters/${this.props.function.theater.slug}/functions`);
        this.setState({
          submitting: false
        });
      },
      error: (error) => {
        this.setState({
          submitting: false
        });
      }
    });
  }
}
