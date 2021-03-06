'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';

import FormControl from 'react-bootstrap/lib/FormControl';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import FormGroup from 'react-bootstrap/lib/FormGroup';

import Select from 'react-select';

export default class FormFieldSelect extends React.Component {
  static propTypes = {
    identifier: PropTypes.string,
    submitKey: PropTypes.string,
    label: PropTypes.string,
    getOptions: PropTypes.func,
    options: PropTypes.array,
    initialValue: PropTypes.object,
    onChange: PropTypes.func,
    async: PropTypes.boolean,
    clearable: PropTypes.boolean
  };
  static defaultProps = {
    label: '',
    initialValue: null,
    async: true,
    clearable: false
  };

  constructor(props) {
    super(props)
    this.state = {
      currentValue: props.initialValue
    };
    _.bindAll(this, '_handleChange');
  }

  render() {
    const SelectComponent = this.props.async ? Select.Async : Select;
    return(
      <FormGroup controlId={this.props.submitKey}>
        <ControlLabel>{this.props.label}</ControlLabel>
        <SelectComponent
          name={this.props.submitKey}
          value={this.state.currentValue}
          onChange={this._handleChange}
          loadOptions={this.props.getOptions}
          options={this.props.options}
          clearable={this.props.clearable}
          cache={false}
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
    const {currentValue} = this.state
    if (currentValue == null) {
      return {[this.props.submitKey]: ' '};
    }
    if (currentValue.value !== this.props.initialValue.value) {
      return {[this.props.submitKey]: currentValue.value};
    }
    return null;
  }
}
