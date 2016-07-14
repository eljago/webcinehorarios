import React, { PropTypes } from 'react';
import _ from 'lodash';
import {FormControl, ControlLabel, FormGroup, HelpBlock} from 'react-bootstrap'
import validator from 'validator';

export default class FormFieldText extends React.Component {
  static propTypes = {
    controlId: PropTypes.string,
    label: PropTypes.string,
    initialValue: PropTypes.string,
    validations: PropTypes.array,
    onChange: PropTypes.func
  };
  static defaultProps = {
    label: '',
    validations: [],
    initialValue: ''
  };

  constructor(props) {
    super(props)
    this.state = {
      currentValue: props.initialValue,
      failedValidations: []
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
      initialValue
    } = this.props

    return(
      <FormGroup
        controlId={controlId}
        validationState={this._getValidationState()}
      >
        <ControlLabel>{label}</ControlLabel>
        <FormControl
          type="text"
          value={this.state.currentValue}
          placeholder={label}
          onChange={(e) => this._handleChange(e.target.value)}
        />

        {this._getFeedback()}
        {this._getHelpBlocks()}
      </FormGroup>
    )
  }

  _handleChange(newValue) {
    let failedValidations = []
    const {validations, onChange, controlId} = this.props;
    _.forIn(validations, (value, key) => {
      if (value === 'notNull' && validator.isNull(newValue)) {
        failedValidations.push('notNull')
      }
    })
    this.setState({
      currentValue: newValue,
      failedValidations: failedValidations
    })
    onChange(controlId, newValue);
  }

  _getValidationState() {
    if (this.props.validations.length == 0) return null
    let validationState = 'success'
    if (this.hasErrors()) {
      validationState = 'error'
    }
    return validationState
  }

  _getFeedback() {
    if (this.props.validations.length > 0)
      return (<FormControl.Feedback />)
    return null
  }

  _getHelpBlocks() {
    let helpBlocks = []
    _.forIn(this.state.failedValidations, (value, key) => {
      if (value === 'notNull') {
        helpBlocks.push(<HelpBlock>{this.props.label} no puede estar en blanco.</HelpBlock>);
      }
    });
    return helpBlocks
  }

  hasErrors() {
    return this.state.failedValidations.length > 0;
  }
}
