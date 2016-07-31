'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormGroup from 'react-bootstrap/lib/FormGroup';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import Checkbox from 'react-bootstrap/lib/Checkbox';

import FormBuilder from '../FormBuilders/FormBuilder'

export default class FormFieldCheckbox extends React.Component {
  static propTypes = {
    fieldId: PropTypes.string,
    formBuilder: PropTypes.instanceOf(FormBuilder),
    submitKey: PropTypes.string,
    label: PropTypes.string,
    initialValue: PropTypes.boolean,
  };
  static defaultProps = {
    label: '',
  };

  constructor(props) {
    super(props)
    this.state = {currentValue: props.initialValue};
    _.bindAll(this, '_handleChange');
  }

  render() {
    const {submitKey, label} = this.props;
    return(
      <FormGroup controlId={submitKey}>
        <ControlLabel>{label}</ControlLabel>
        <Checkbox
          checked={this.state.currentValue}
          onChange={this._handleChange}
        >
          {this.props.label}
        </Checkbox>
      </FormGroup>
    );
  }

  _handleChange(e) {
    this.setState({currentValue: !this.state.currentValue});
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
