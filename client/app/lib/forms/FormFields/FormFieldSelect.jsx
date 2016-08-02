'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';

import FormControl from 'react-bootstrap/lib/FormControl';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import FormGroup from 'react-bootstrap/lib/FormGroup';

import Select from 'react-select';

import FormBuilder from '../FormBuilders/FormBuilder'

export default class FormFieldSelect extends React.Component {
  static propTypes = {
    submitKey: PropTypes.string,
    label: PropTypes.string,
    getOptions: PropTypes.array,
    initialValue: PropTypes.object,
    onChange: PropTypes.func,
  };
  static defaultProps = {
    label: '',
    initialValue: ''
  };

  constructor(props) {
    super(props)
    this.state = {
      currentValue: props.initialValue
    };
    _.bindAll(this, '_handleChange');
  }

  render() {
    return(
      <FormGroup controlId={this.props.submitKey}>
        <ControlLabel>{this.props.label}</ControlLabel>
        <Select.Async
          name={this.props.submitKey}
          value={this.state.currentValue}
          onChange={this._handleChange}
          loadOptions={this.props.getOptions}
          clearable={false}
        />
      </FormGroup>
    )
  }

  _handleChange(newValue) {
    this.setState({currentValue: newValue});
    if (_.isFunction(this.props.onChange)) {
      this.props.onChange(newValue);
    }
  }

  getResult() {
    const initialValue = this.props.initialValue;
    if (this.state.currentValue.value != initialValue.value) {
      let result = {}
      return {[this.props.submitKey]: this.state.currentValue.value};
    }
    return null;
  }
}
