'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Radio from 'react-bootstrap/lib/Radio';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import FormGroup from 'react-bootstrap/lib/FormGroup';

import FormBuilder from '../FormBuilders/FormBuilder'

export default class FormFieldRadioGroup extends React.Component {
  static propTypes = {
    fieldId: PropTypes.string,
    formBuilder: PropTypes.instanceOf(FormBuilder),
    submitKey: PropTypes.string,
    label: PropTypes.string,
    options: PropTypes.array.isRequired,
    initialValue: PropTypes.string,
  };
  static defaultProps = {
    label: '',
  };

  constructor(props) {
    super(props)
    this.state = {currentValue: props.initialValue};
    _.bindAll(this, ['_handleChange', '_getRadioElements']);
  }

  render() {
    const {submitKey, label} = this.props;
    return(
      <FormGroup controlId={submitKey}>
        <ControlLabel>{label}</ControlLabel>
        {this._getRadioElements()}
      </FormGroup>
    );
  }

  _getRadioElements() {
    return this.props.options.map((opt, i) => {
      return (
        <Radio
          checked={opt.value === this.state.currentValue}
          onChange={(e) => {
            this._handleChange(opt.value);
          }}
        >
          {opt.label}
        </Radio>
      );
    });
  }

  _handleChange(value) {
    let newSelectedValue = "";
    if (value != this.state.currentValue) {
      newSelectedValue = value;
    }
    this.setState({currentValue: newSelectedValue});
  }

  getResult() {
    if (this.state.currentValue !== this.props.initialValue) {
      let result = {}
      result[this.props.submitKey] = this.state.currentValue;
      return result;
    }
    return null;
  }
}
