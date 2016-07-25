'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import moment from 'moment'

import DateTimeField from 'react-bootstrap-datetimepicker'
import FormControl from 'react-bootstrap/lib/FormControl';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import FormGroup from 'react-bootstrap/lib/FormGroup';

export default class FormFieldDate extends React.Component {
  static propTypes = {
    controlId: PropTypes.string,
    label: PropTypes.string,
    initialValue: PropTypes.string,
  };
  static defaultProps = {
    label: '',
  };

  constructor(props) {
    super(props)
    const momentDate = props.initialValue ? moment(props.initialValue) : moment();
    this.initialValue = momentDate.format("YYYY-MM-DD");
    this.state = {
      currentValue: this.initialValue
    };
    _.bindAll(this, '_handleChange');
  }

  render() {
    const {controlId, label} = this.props;
    return(
      <FormGroup controlId={controlId}>
        <ControlLabel>{label}</ControlLabel>
        <DateTimeField
          dateTime={this.state.currentValue}
          onChange={this._handleChange}
          format='YYYY-MM-DD'
          viewMode="date"
          inputFormat="DD-MM-YYYY"
        />
      </FormGroup>
    );
  }

  _handleChange(date) {
    this.setState({currentValue: date});
  }

  getResult() {
    if (!_.isEqual(this.state.currentValue, this.initialValue)) {
      let result = {}
      result[this.props.controlId] = this.state.currentValue;
      return result;
    }
    return null;
  }
}
