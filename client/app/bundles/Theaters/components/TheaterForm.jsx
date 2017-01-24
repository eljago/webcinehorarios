'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';

import ErrorMessages from '../../../lib/forms/FormFields/ErrorMessages'
import FormFieldText from '../../../lib/forms/FormFields/FormFieldText'
import FormFieldCheckbox from '../../../lib/forms/FormFields/FormFieldCheckbox'
import FormFieldRadioGroup from '../../../lib/forms/FormFields/FormFieldRadioGroup'

import Button from 'react-bootstrap/lib/Button';

import FormBuilder from '../../../lib/forms/FormBuilder';

export default class TheaterForm extends React.Component {

  static propTypes = {
    formBuilder: PropTypes.instanceOf(FormBuilder),
    errors: PropTypes.array,
    submitting: PropTypes.boolean,
  };

  render() {
    const {formBuilder, submitting, errors} = this.props;

    return (
      <form>
        <ErrorMessages errors={errors} />

        {formBuilder.getField('name', {disabled: submitting})}
        {formBuilder.getField('active', {disabled: submitting})}
        {formBuilder.getField('address', {disabled: submitting})}
        {formBuilder.getField('web_url', {disabled: submitting})}
        {formBuilder.getField('parse_helper', {disabled: submitting})}
        {formBuilder.getField('information', {disabled: submitting})}
        {formBuilder.getField('parent_theater_id', {
          initialValue: {
            value: formBuilder.object.parent_theater.id,
            label: formBuilder.object.parent_theater.name
          },
          clearable: true
        })}
        {formBuilder.getField('latitude', {
          disabled: submitting,
          step: '0.0000001'
        })}
        {formBuilder.getField('longitude', {
          disabled: submitting,
          step: '0.0000001'
        })}
        {formBuilder.getSubmitButton({
          disabled: submitting
        })}
        {this._getDeleteButton()}
      </form>
    );
  }

  _getDeleteButton() {
    if (this.props.formBuilder.object.id) {
      return this.props.formBuilder.getDeleteButton({
        disabled: this.props.submitting
      });
    }
    return null;
  }

  getResult() {
    let result = {};
    _.forIn(this.refs, (formElement) => {
      if (_.isFunction(formElement.getResult)) {
        _.merge(result, formElement.getResult());
      }
    });
    console.log(result)
    return result;
  }
}
