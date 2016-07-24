'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';

import FormControl from 'react-bootstrap/lib/FormControl';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import FormGroup from 'react-bootstrap/lib/FormGroup';
import HelpBlock from 'react-bootstrap/lib/HelpBlock';

export default class FormFieldText extends React.Component {
  static propTypes = {
    type: PropTypes.string,
    controlId: PropTypes.string,
    onChange: PropTypes.func,
    label: PropTypes.string,
    initialValue: PropTypes.string,
    regExp: PropTypes.object,
  };
  static defaultProps = {
    type: 'text',
    label: '',
    initialValue: '',
    regExp: null
  };

  constructor(props) {
    super(props);

    this.state = {
      currentValue: props.initialValue,
      valid: props.regExp ? props.regExp.test(props.initialValue) : true,
    };
    _.bindAll(this, '_handleChange');
  }

  render() {
    const {
      controlId,
      label,
      initialValue,
      type
    } = this.props;

    const typeProps = type === 'textarea' ?
      {componentClass: type, rows: 7} :
      {type: type};

    return(
      <FormGroup
        controlId={controlId}
        validationState={this._getValidationState()}
      >
        <ControlLabel>{label}</ControlLabel>
        <FormControl
          {...typeProps}
          value={this.state.currentValue}
          placeholder={label}
          onChange={(e) => {
            this._handleChange(_.replace(e.target.value,'  ', ' '))
          }}
          required
        />
        {this._getFeedback()}
      </FormGroup>
    )
  }

  _handleChange(value) {
    const newValue = _.trim(value);
    let newState = {currentValue: newValue};

    if (this.props.regExp)
      newState.valid = this.props.regExp.test(newValue);

    this.setState(newState);

    const {onChange, controlId} = this.props;
    onChange(controlId, newValue);
  }

  _getValidationState() {
    if (this.props.regExp) {
      if (this.state.valid)
        return 'success';
      else
        return 'error';
    }
    return null;
  }

  _getFeedback() {
    if (this.props.regExp)
      return (<FormControl.Feedback />);
    return null;
  }
}