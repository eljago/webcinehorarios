'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';

import validate from './validate';

import FormControl from 'react-bootstrap/lib/FormControl';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import FormGroup from 'react-bootstrap/lib/FormGroup';
import HelpBlock from 'react-bootstrap/lib/HelpBlock';

import FormBuilder from '../FormBuilders/FormBuilder'

export default class FormFieldText extends React.Component {
  static propTypes = {
    fieldId: PropTypes.string,
    formBuilder: PropTypes.instanceOf(FormBuilder),
    type: PropTypes.string,
    submitKey: PropTypes.string,
    label: PropTypes.string,
    initialValue: PropTypes.string,
    validations: PropTypes.object,
  };
  static defaultProps = {
    type: 'text',
    label: '',
    initialValue: '',
    validations: null,
  };

  constructor(props) {
    super(props);

    this.state = {
      currentValue: props.initialValue,
      helpMessages: _.values(validate(props.initialValue, props.validations))
    };
  }

  render() {
    const {
      submitKey,
      label,
      initialValue,
      type
    } = this.props;

    const typeProps = type === 'textarea' ?
      {componentClass: type, rows: 7} : {type: type};

    return(
      <FormGroup
        controlId={submitKey}
        validationState={this._getValidationState()}
      >
        <ControlLabel>{label}</ControlLabel>
        <FormControl
          {...typeProps}
          value={this.state.currentValue}
          placeholder={label}
          onChange={(e) => {
            this._handleChange(e.target.value)
          }}
        />
        {this._getFeedback()}
      </FormGroup>
    )
  }

  _handleChange(value) {
    const newValue = _.replace(value, '  ', ' ');
    this.setState({
      currentValue: newValue,
      helpMessages: _.values(validate(newValue, this.props.validations))
    });
  }

  _getValidationState() {
    if (this.props.validations) {
      return this.state.helpMessages.length > 0 ? 'error' : 'success';
    }
    return null;
  }

  _getFeedback() {
    if (this.props.validations) {
      let helperElements = [<FormControl.Feedback />];
      _.forIn(this.state.helpMessages, (message) => {
        helperElements.push(<HelpBlock>{message}</HelpBlock>);
      });
      return helperElements;
    }
    return null;
  }

  getResult() {
    if (this.state.currentValue !== this.props.initialValue) {
      let result = {}
      result[this.props.submitKey] = _.trim(this.state.currentValue);
      return result;
    }
    return null;
  }
}
