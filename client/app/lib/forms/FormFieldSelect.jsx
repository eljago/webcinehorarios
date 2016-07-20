import React, { PropTypes } from 'react';
import _ from 'lodash';
import {FormControl, ControlLabel, FormGroup} from 'react-bootstrap'

export default class FormFieldSelect extends React.Component {
  static propTypes = {
    controlId: PropTypes.string,
    onChange: PropTypes.func,
    label: PropTypes.string,
    values: PropTypes.array,
  };
  static defaultProps = {
    label: '',
  };

  constructor(props) {
    super(props)
    this.state = {
      currentValue: props.initialValue,
    };
    _.bindAll(this, '_handleChange');
  }

  componentDidMount() {
    this._handleChange(this.state.currentValue);
  }

  render() {
    const {
      controlId,
      label,
    } = this.props;

    return(
      <FormGroup controlId={controlId}>
        <ControlLabel>{label}</ControlLabel>
        <FormControl
          componentClass="select"
          placeholder={label}
          onChange={(e) => {
            this._handleChange(_.replace(e.target.value,'  ', ' '))
          }}
        >
          {this._getOptions()}
        </FormControl>
      </FormGroup>
    )
  }

  _getOptions() {
    return this.props.values.map((value) => {
      return (<option value={value}>{value}</option>);
    })
  }

  _handleChange(newValue) {
    const {onChange, controlId} = this.props;
    onChange(controlId, newValue);
  }
}
