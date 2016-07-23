'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';

import FormControl from 'react-bootstrap/lib/FormControl';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import FormGroup from 'react-bootstrap/lib/FormGroup';

export default class FormFieldSelect extends React.Component {
  static propTypes = {
    controlId: PropTypes.string,
    onChange: PropTypes.func,
    label: PropTypes.string,
    values: PropTypes.array,
  };
  static defaultProps = {
    label: '',
  };

  constructor(props) {
    super(props)
    this.state = {
      currentValue: props.initialValue,
    };
    _.bindAll(this, '_handleChange');
  }

  render() {
    const {
      controlId,
      label,
    } = this.props;

    return(
      <FormGroup controlId={controlId}>
        <ControlLabel>{label}</ControlLabel>
        <FormControl
          componentClass="select"
          placeholder={label}
          onChange={(e) => {
            this._handleChange(_.replace(e.target.value,'  ', ' '))
          }}
        >
          {this._getOptions()}
        </FormControl>
      </FormGroup>
    )
  }

  _getOptions() {
    return this.props.values.map((value) => {
      return (<option value={value}>{value}</option>);
    })
  }

  _handleChange(newValue) {
    const {onChange, controlId} = this.props;
    onChange(controlId, newValue);
  }
}
