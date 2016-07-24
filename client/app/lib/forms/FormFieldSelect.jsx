'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';

import FormControl from 'react-bootstrap/lib/FormControl';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import FormGroup from 'react-bootstrap/lib/FormGroup';

import Select from 'react-select';

export default class FormFieldSelect extends React.Component {
  static propTypes = {
    controlId: PropTypes.number,
    onChange: PropTypes.func,
    label: PropTypes.string,
    getOptions: PropTypes.array,
    initialValue: PropTypes.object,
  };
  static defaultProps = {
    label: '',
    initialValue: '',
  };

  constructor(props) {
    super(props)
    this.state = {
      currentValue: props.initialValue
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
        <Select.Async
          name={controlId}
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
    const {onChange, controlId} = this.props;
    onChange(controlId, newValue);
  }
}