import React, { PropTypes } from 'react'
import {FormControl, ControlLabel, FormGroup} from 'react-bootstrap'
import _ from 'lodash'
import moment from 'moment'
// import DatePicker from 'react-datepicker'
var DatePicker = require("react-bootstrap-date-picker");

export default class FormFieldDate extends React.Component {
  static propTypes = {
    controlId: PropTypes.string,
    onChange: PropTypes.func,
    label: PropTypes.string
  };
  static defaultProps = {
    label: '',
  };

  constructor(props) {
    super(props)
    this.state = {
      date: new Date().toISOString()
    };
    _.bindAll(this, '_handleChange');
  }

  componentDidMount() {
    this._handleChange(this.state.date);
  }

  render() {
    const {controlId, label} = this.props;
    return(
      <FormGroup controlId={controlId}>
        <ControlLabel>{label}</ControlLabel>
        <DatePicker
          value={this.state.date}
          onChange={this._handleChange}
        />
      </FormGroup>
    );
  }

  _handleChange(date) {
    const {controlId, onChange} = this.props;
    this.setState({date});
    onChange(controlId, moment(date).format('YYYY-MM-DD'));
  }
}
