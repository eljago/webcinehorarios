'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormGroup from 'react-bootstrap/lib/FormGroup';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import Checkbox from 'react-bootstrap/lib/Checkbox';

export default class FormFieldCheckbox extends React.Component {
  static propTypes = {
    submitKey: PropTypes.string,
    label: PropTypes.string,
    initialValue: PropTypes.boolean,
    getResultForValue: PropTypes.func,
    onChange: PropTypes.func,
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
    if (this.props.onChange) {
      this.props.onChange(!this.state.currentValue);
    }
    this.setState({currentValue: !this.state.currentValue});
  }

  setValue(newValue) {
    this.setState({currentValue: newValue});
  }

  getResult() {
    console.log(this.props.initialValue)
    console.log(this.state.currentValue)
    if (this.state.currentValue != this.props.initialValue) {
      if (this.props.getResultForValue) {
        return {[this.props.submitKey]: this.props.getResultForValue(this.state.currentValue)};
      }
      else {
        return {[this.props.submitKey]: this.state.currentValue};
      }
    }
    return null;
  }
}
