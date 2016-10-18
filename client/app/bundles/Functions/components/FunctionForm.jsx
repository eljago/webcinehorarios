'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormRow from './FormRow'

import ErrorMessages from '../../../lib/forms/FormFields/ErrorMessages'

import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

export default class FunctionForm extends React.Component {

  static propTypes = {
    formBuilders: PropTypes.array,
    errors: PropTypes.object,
    submitting: PropTypes.boolean,
  };

  render() {
    const {errors, submitting} = this.props;
    return(
      <form>
        <ErrorMessages errors={errors} />
        {this._getContentRows()}
      </form>
    );
  }

  _getContentRows() {
    return this.props.formBuilders.map((formBuilder, index) => {
      return(
        <FormRow
          key={formBuilder.object.id}
          ref={`show${formBuilder.object.id}`}
          formBuilder={formBuilder}
          index={index}
        />
      );
    });
  }

  getResult() {
    let showResult = {};
    _.forIn(this.refs, (formElement) => {
      if (_.isFunction(formElement.getResult)) {
        _.merge(showResult, formElement.getResult());
      }
    });
    return showResult;
  }
}