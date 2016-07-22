'use strict';

import React, { PropTypes } from 'react'
import {Checkbox, ControlLabel, FormGroup} from 'react-bootstrap'
import _ from 'lodash'

export default class FormFieldCheckboxGroup extends React.Component {
  static propTypes = {
    controlId: PropTypes.string,
    onChange: PropTypes.func,
    label: PropTypes.string,
    options: PropTypes.array.isRequired,
    selectedValues: PropTypes.array,
  };
  static defaultProps = {
    label: '',
  };

  constructor(props) {
    super(props)
    this.state = {
      selectedValues: props.selectedValues
    };
    _.bindAll(this, ['_handleChange', '_getCheckboxElements']);
  }

  render() {
    const {controlId, label} = this.props;
    return(
      <FormGroup controlId={controlId}>
        <ControlLabel>{label}</ControlLabel>
        {this._getCheckboxElements()}
      </FormGroup>
    );
  }

  _getCheckboxElements() {
    return this.props.options.map((opt, i) => {
      return (
        <Checkbox
          checked={this.state.selectedValues.includes(opt.value)}
          onChange={(e) => {
            this._handleChange(opt.value);
          }}
        >
          {opt.label}
        </Checkbox>
      );
    });
  }

  _handleChange(value) {
    let selectedValues = this.state.selectedValues;
    if (selectedValues.includes(value)) {
      _.pull(selectedValues, value);
    }
    else {
      selectedValues.push(value);
    }
    this.setState({selectedValues});
    const {controlId, onChange} = this.props;
    onChange(controlId, selectedValues);
    console.log(selectedValues);
    console.log(value);
  }
}
