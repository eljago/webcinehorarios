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
    onChange: PropTypes.func,
    label: PropTypes.string,
    date: PropTypes.string,
  };
  static defaultProps = {
    label: '',
  };

  constructor(props) {
    super(props)
    const momentDate = props.date ? moment(props.date) : moment();
    this.state = {
      date: momentDate.format("YYYY-MM-DD")
    };
    _.bindAll(this, '_handleChange');
  }

  render() {
    const {controlId, label} = this.props;
    return(
      <FormGroup controlId={controlId}>
        <ControlLabel>{label}</ControlLabel>
        <DateTimeField
          dateTime={this.state.date}
          onChange={this._handleChange}
          format='YYYY-MM-DD'
          viewMode="date"
          inputFormat="DD-MM-YYYY"
        />
      </FormGroup>
    );
  }

  _handleChange(date) {
    const {controlId, onChange} = this.props;
    this.setState({date});
    onChange(controlId, date);
  }
}
