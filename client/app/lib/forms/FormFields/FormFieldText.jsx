'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';

import FormControl from 'react-bootstrap/lib/FormControl';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import FormGroup from 'react-bootstrap/lib/FormGroup';

export default class FormFieldText extends React.Component {
  static propTypes = {
    type: PropTypes.string,
    submitKey: PropTypes.string,
    label: PropTypes.string,
    initialValue: PropTypes.string,
    disabled: PropTypes.boolean,
  };
  static defaultProps = {
    type: 'text',
    label: '',
    initialValue: '',
  };

  constructor(props) {
    super(props);

    this.state = {currentValue: props.initialValue};
  }

  render() {
    const {
      submitKey,
      label,
      initialValue,
      type
    } = this.props;

    const typeProps = type === 'textarea' ?
      {componentClass: type, rows: 7} : 
        (type === 'number' ? {type: type, step: this.props.step ? this.props.step : 1} : 
          {type: type});

    return(
      <FormGroup controlId={submitKey}>
        {this._getControlLabel()}
        <FormControl
          {...typeProps}
          value={this.state.currentValue}
          placeholder={label}
          onChange={(e) => {
            this._handleChange(e.target.value)
          }}
          disabled={this.props.disabled}
        />
      </FormGroup>
    )
  }

  _getControlLabel() {
    if (this.props.label && !_.isEmpty(this.props.label)) {
      return <ControlLabel>{this.props.label}</ControlLabel>
    }
    return null;
  }

  _handleChange(value) {
    const currentValue = _.replace(value, '  ', ' ');
    this.setState({currentValue});
  }

  getResult() {
    if (this.state.currentValue !== this.props.initialValue) {
      return {[this.props.submitKey]: _.trim(this.state.currentValue)};
    }
    return null;
  }
}
