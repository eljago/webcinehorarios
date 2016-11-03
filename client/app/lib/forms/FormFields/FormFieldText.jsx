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
    horizontal: PropTypes.boolean,
  };
  static defaultProps = {
    type: 'text',
    label: '',
    initialValue: '',
    placeholder: '',
    horizontal: false,
  };

  constructor(props) {
    super(props);
    this.state = {
      value: props.initialValue,
    }
    _.bindAll(this, '_handleChange');
  }

  render() {
    const className = this.props.horizontal ? {className: "form-horizontal"} : null;
    return(
      <div {...className}>
        <div className="form-group">
          {this._getControlLabel()}
          {this._getInputContent()}
        </div>
      </div>
    );
  }

  _handleChange(event) {
    this.setState({value: event.target.value});
  }

  _getControlLabel() {
    if (this.props.label && !_.isEmpty(this.props.label)) {
      const horizontalClass = this.props.horizontal ? "col-sm-2" : "";
      return (
        <label className={`${horizontalClass} control-label`} for={this.props.identifier}>
          {this.props.label}
        </label>
      );
    }
    return null;
  }

  _getInputContent() {
    if (this.props.horizontal) {
      return(
        <div className="col-sm-10">
          {this._getInput()}
        </div>
      );
    }
    else {
      return this._getInput();
    }
  }

  _getInput() {
    const {
      label,
      type,
      placeholder,
      identifier,
    } = this.props;

    const inputProps = {
      className: 'form-control',
      id: identifier,
      placeholder: placeholder,
      disabled: this.props.disabled,
      value: this.state.value,
      onChange: this._handleChange,
    }

    if (type === 'textarea') {
      return <textarea {...inputProps} rows='7' />;
    }
    else if (type === 'number') {
      return <input type={type} {...inputProps} step={this.props.step ? this.props.step : 1} />;
    }
    else {
      return <input type={type} {...inputProps} />
    }
  }

  getResult() {
    if (this.state.value !== this.props.initialValue) {
      return {[this.props.submitKey]: _.trim(this.state.value)};
    }
    return null;
  }
}
