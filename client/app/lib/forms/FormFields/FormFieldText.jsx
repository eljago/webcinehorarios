'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';

export default class FormFieldText extends React.Component {
  static propTypes = {
    identifier: PropTypes.string,
    type: PropTypes.string,
    submitKey: PropTypes.string,
    label: PropTypes.string,
    initialValue: PropTypes.string,
    disabled: PropTypes.boolean,
    placeholder: PropTypes.string,
  };
  static defaultProps = {
    type: 'text',
    label: '',
    initialValue: '',
  };

  constructor(props) {
    super(props);
    this.state = {
      value: props.initialValue,
    }
    _.bindAll(this, '_handleChange');
  }

  render() {
    const {
      submitKey,
      label,
      initialValue,
      type,
      placeholder,
      identifier,
    } = this.props;

    const typeProps = type === 'textarea' ?
      {componentClass: type, rows: 7} : 
        (type === 'number' ? {type: type, step: this.props.step ? this.props.step : 1} : 
          {type: type});

    return(
      <div className="form-group">
        {this._getControlLabel()}
        <input
          {...typeProps}
          className="form-control"
          id={identifier}
          placeholder={placeholder ? placeholder : label}
          disabled={this.props.disabled}
          value={this.state.value}
          onChange={this._handleChange}
        />
      </div>
    );
  }

  _handleChange(event) {
    this.setState({value: event.target.value});
  }

  _getControlLabel() {
    if (this.props.label && !_.isEmpty(this.props.label)) {
      return (
        <label className='control-label' for={this.props.identifier}>
          {this.props.label}
        </label>
      );
    }
    return null;
  }

  getResult() {
    if (this.state.value !== this.props.initialValue) {
      return {[this.props.submitKey]: _.trim(this.state.value)};
    }
    return null;
  }
}
