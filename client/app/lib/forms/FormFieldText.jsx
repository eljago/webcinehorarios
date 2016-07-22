'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';
import {FormControl, ControlLabel, FormGroup, HelpBlock} from 'react-bootstrap'
import validator from 'validator';

export default class FormFieldText extends React.Component {
  static propTypes = {
    type: PropTypes.string,
    controlId: PropTypes.string,
    onChange: PropTypes.func,
    label: PropTypes.string,
    initialValue: PropTypes.string,
    validations: PropTypes.array,
  };
  static defaultProps = {
    type: 'text',
    label: '',
    initialValue: '',
    validations: [],
  };

  constructor(props) {
    super(props)
    this.state = {
      currentValue: props.initialValue,
      failedValidations: [],
    };
    _.bindAll(this, '_handleChange');
  }

  render() {
    const {
      controlId,
      label,
      initialValue,
      type
    } = this.props;

    const typeProps = type === 'textarea' ? 
      {componentClass: type, rows: 7} : 
      {type: type}

    return(
      <FormGroup
        controlId={controlId}
        validationState={this._getValidationState()}
      >
        <ControlLabel>{label}</ControlLabel>
        <FormControl
          {...typeProps}
          value={this.state.currentValue}
          placeholder={label}
          onChange={(e) => {
            this._handleChange(_.replace(e.target.value,'  ', ' '))
          }}
          required
        />
        {this._getFeedback()}
        {this._getHelpBlocks()}
      </FormGroup>
    )
  }

  _handleChange(newValue) {
    this.setState({
      currentValue: newValue,
      failedValidations: this._getFailedValidations(newValue),
    });
    const {onChange, controlId} = this.props;
    onChange(controlId, _.trim(newValue));
  }

  _getValidationState() {
    if (this.props.validations.length == 0)
      return null;
    let validationState = 'success';
    if (this.hasErrors()) {
      validationState = 'error';
    }
    return validationState;
  }

  _getFeedback() {
    if (this.props.validations.length > 0)
      return (<FormControl.Feedback />);
    return null;
  }
  _getHelpBlocks() {
    let helpBlocks = [];
    _.forIn(this.state.failedValidations, (value, key) => {
      if (value === 'notNull') {
        helpBlocks.push(
          <HelpBlock>{this.props.label} no puede estar en blanco.</HelpBlock>
        );
      }
    });
    return helpBlocks;
  }

  hasErrors() {
    return this.state.failedValidations.length > 0;
  }

  _getFailedValidations(value) {
    let failedValidations = [];
    _.forIn(this.props.validations, (validation) => {
      switch (validation){
        case 'notNull':
          if (validator.isNull(newValue)) {
            failedValidations.push('notNull');
          }
          break;
        default:
          break;
      }
    });
    return failedValidations;
  }
}
