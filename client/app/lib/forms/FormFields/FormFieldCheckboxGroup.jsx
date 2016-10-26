'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Checkbox from 'react-bootstrap/lib/Checkbox';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import FormGroup from 'react-bootstrap/lib/FormGroup';

export default class FormFieldCheckboxGroup extends React.Component {
  static propTypes = {
    identifier: PropTypes.string,
    submitKey: PropTypes.string,
    label: PropTypes.string,
    options: PropTypes.array.isRequired,
    initialValue: PropTypes.array,
    columns: PropTypes.number,
  };
  static defaultProps = {
    label: '',
    columns: 1,
  };

  constructor(props) {
    super(props)
    this.state = {currentValue: [].concat(props.initialValue)};
    _.bindAll(this, '_handleChange');
  }

  render() {
    const {submitKey, label} = this.props;

    return(
      <FormGroup controlId={submitKey}>
        <ControlLabel>{label}</ControlLabel>
        {this._getCheckboxElements()}
      </FormGroup>
    );
  }

  _getCheckboxElements() {
    let checkboxes = [];
    for (let indx = 0; indx < this.props.columns; indx ++) {
      checkboxes.push([]);
    } // [[][][]]

    const optionsCount = this.props.options.length;
    const columnCount = this.props.columns;
    for (let indx = 0; indx < optionsCount; indx++) {
      const opt = this.props.options[indx];
      checkboxes[Math.floor(indx / (optionsCount/columnCount))].push(
        <Checkbox
          checked={this.state.currentValue.includes(opt.value)}
          onChange={(e) => {
            this._handleChange(opt.value);
          }}
        >
          {opt.label}
        </Checkbox>
      );
    }
    return (
      <div style={{display: 'flex', flexDirection: 'row'}}>
        {checkboxes.map((chbxs, indx) => {
          return (
            <div style={{display: 'flex', flexDirection: 'column', ...(indx > 0 ? {marginLeft: 6} : null)}}>
              {chbxs.map((chbx) => {
                return chbx;
              })}
            </div>
          );
        })}
      </div>
    );
  }

  _handleChange(value) {
    let currentValue = this.state.currentValue;
    if (currentValue.includes(value)) {
      _.pull(currentValue, value);
    }
    else {
      currentValue.push(value);
    }
    console.log(currentValue);
    this.setState({currentValue});
  }

  getResult() {
    if (!_.isEqual(this.state.currentValue, this.props.initialValue)) {
      const newValue = this.state.currentValue.length > 0 ? this.state.currentValue : [' ']
      return {[this.props.submitKey]: newValue};
    }
    return null;
  }
}
