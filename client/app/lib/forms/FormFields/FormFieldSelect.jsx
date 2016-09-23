'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';

import FormControl from 'react-bootstrap/lib/FormControl';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import FormGroup from 'react-bootstrap/lib/FormGroup';

import Select from 'react-select';

export default class FormFieldSelect extends React.Component {
  static propTypes = {
    submitKey: PropTypes.string,
    label: PropTypes.string,
    getOptions: PropTypes.func,
    options: PropTypes.array,
    initialValue: PropTypes.object,
    onChange: PropTypes.func,
    async: PropTypes.boolean,
  };
  static defaultProps = {
    label: '',
    initialValue: '',
    async: true
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
          clearable={false}
          cache={true}
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
    if (this.state.currentValue.value != this.props.initialValue.value) {
      return {[this.props.submitKey]: this.state.currentValue.value};
    }
    return null;
  }
}
