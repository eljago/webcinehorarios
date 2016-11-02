'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormGroup from 'react-bootstrap/lib/FormGroup';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import Checkbox from 'react-bootstrap/lib/Checkbox';

export default class FormFieldCheckbox extends React.Component {
  static propTypes = {
    identifier: PropTypes.string,
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
    this.state = {
      currentValue: props.initialValue
    };
    _.bindAll(this, '_handleChange');
  }

  render() {
    const {submitKey, label} = this.props;
    return(
      <FormGroup controlId={submitKey}>
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
    if (this.state.currentValue != this.props.initialValue) {
      return {[this.props.submitKey]: this.state.currentValue};
    }
    return null;
  }
}
