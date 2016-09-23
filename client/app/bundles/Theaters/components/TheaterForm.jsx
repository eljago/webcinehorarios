'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';

import ErrorMessages from '../../../lib/forms/FormFields/ErrorMessages'
import FormFieldText from '../../../lib/forms/FormFields/FormFieldText'
import FormFieldCheckbox from '../../../lib/forms/FormFields/FormFieldCheckbox'
import FormFieldRadioGroup from '../../../lib/forms/FormFields/FormFieldRadioGroup'

import Button from 'react-bootstrap/lib/Button';

export default class TheaterForm extends React.Component {

  static propTypes = {
    errors: PropTypes.array,
    theater: PropTypes.object,
    onSubmit: PropTypes.func,
  };

  constructor(props) {
    super(props);
    this.state = {
      submitting: false
    }
    _.bindAll(this, '_onSubmit');
  }

  render() {
    const theater = this.props.theater;
    const submitting = this.state.submitting;

    return (
      <form>
        <ErrorMessages errors={this.props.errors} />

        <FormFieldText
          submitKey='name'
          label='Nombre'
          ref='name'
          initialValue={theater ? theater.name : ''}
        />
        <FormFieldCheckbox
          submitKey='active'
          label='Activo?'
          ref='active'
          initialValue={theater ? theater.active : false}
        />
        <FormFieldText
          submitKey='address'
          label='Dirección'
          ref='address'
          initialValue={theater ? theater.address : ''}
        />
        <FormFieldText
          submitKey='web_url'
          label='Web URL'
          ref='web_url'
          initialValue={theater ? theater.web_url : ''}
        />
        <FormFieldText
          submitKey='parse_helper'
          label='Parse Helper'
          ref='parse_helper'
          initialValue={theater ? theater.parse_helper : ''}
        />
        <FormFieldText
          type='textarea'
          submitKey='information'
          label='Información'
          ref='information'
          initialValue={theater ? theater.information : ''}
        />
        <FormFieldText
          type='number'
          step='0.0000001'
          submitKey='latitude'
          label='Latitud'
          ref='latitude'
          initialValue={theater ? theater.latitude : ''}
        />
        <FormFieldText
          type='number'
          step='0.0000001'
          submitKey='longitude'
          label='Longitud'
          ref='longitude'
          initialValue={theater ? theater.longitude : ''}
        />
        <Button
          bsStyle="primary"
          type="submit"
          disabled={submitting}
          onClick={this._onSubmit}
        >
          {submitting ? 'Submitting...' : 'Submit'}
        </Button>
      </form>
    );
  }

  _onSubmit(e) {
    this.setState({submitting: true});
    const theaterToSubmit = this._getResult();
    this.props.onSubmit(theaterToSubmit, (success) => {
      if (success) {
        console.log("SUCCESS");
      }
      else {
        console.log("ERROR");
      }
      this.setState({submitting: false});
    });
    e.preventDefault();
  }

  _getResult() {
    let theaterResult = this.props.theater ? {id: this.props.theater.id} : {};
    _.forIn(this.refs, (formElement) => {
      if (_.isFunction(formElement.getResult)) {
        _.merge(theaterResult, formElement.getResult());
      }
    });
    return theaterResult;
  }
}
