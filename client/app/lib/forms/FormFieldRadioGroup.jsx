'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Radio from 'react-bootstrap/lib/Radio';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import FormGroup from 'react-bootstrap/lib/FormGroup';

export default class FormFieldRadioGroup extends React.Component {
  static propTypes = {
    controlId: PropTypes.string,
    onChange: PropTypes.func,
    label: PropTypes.string,
    options: PropTypes.array.isRequired,
    selectedValue: PropTypes.string,
  };
  static defaultProps = {
    label: '',
  };

  constructor(props) {
    super(props)
    this.state = {
      selectedValue: props.selectedValue
    };
    _.bindAll(this, ['_handleChange', '_getRadioElements']);
  }

  render() {
    const {controlId, label} = this.props;
    return(
      <FormGroup controlId={controlId}>
        <ControlLabel>{label}</ControlLabel>
        {this._getRadioElements()}
      </FormGroup>
    );
  }

  _getRadioElements() {
    return this.props.options.map((opt, i) => {
      return (
        <Radio
          checked={opt.value === this.state.selectedValue}
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
    if (value != this.state.selectedValue) {
      newSelectedValue = value;
    }
    this.setState({selectedValue: newSelectedValue});
    const {controlId, onChange} = this.props;
    onChange(controlId, newSelectedValue);
  }
}
