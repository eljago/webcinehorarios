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
      {componentClass: type, rows: 7} : {type: type};

    return(
      <FormGroup controlId={submitKey}>
        <ControlLabel>{label}</ControlLabel>
        <FormControl
          {...typeProps}
          value={this.state.currentValue}
          placeholder={label}
          onChange={(e) => {
            this._handleChange(e.target.value)
          }}
        />
      </FormGroup>
    )
  }

  _handleChange(value) {
    const newValue = _.replace(value, '  ', ' ');
    this.setState({currentValue: newValue});
  }

  getResult() {
    if (this.state.currentValue !== this.props.initialValue) {
      return result[this.props.submitKey] = _.trim(this.state.currentValue);
    }
    return null;
  }
}
