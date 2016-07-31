'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Checkbox from 'react-bootstrap/lib/Checkbox';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import FormGroup from 'react-bootstrap/lib/FormGroup';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

import FormBuilder from '../FormBuilders/FormBuilder'

export default class FormFieldCheckboxGroup extends React.Component {
  static propTypes = {
    fieldId: PropTypes.string,
    formBuilder: PropTypes.instanceOf(FormBuilder),
    submitKey: PropTypes.string,
    label: PropTypes.string,
    options: PropTypes.array.isRequired,
    initialValue: PropTypes.array,
  };
  static defaultProps = {
    label: '',
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
        <Row>
          {this._getCheckboxColumns()}
        </Row>
      </FormGroup>
    );
  }

  _getCheckboxElements() {
    return this.props.options.map((opt, i) => {
      return (
        <Checkbox
          checked={this.state.currentValue.includes(opt.value)}
          onChange={(e) => {
            this._handleChange(opt.value);
          }}
        >
          {opt.label}
        </Checkbox>
      );
    });
  }

  _getCheckboxColumns() {
    const {fieldId, formBuilder} = this.props;

    let checkboxCols = [];

    const formSchema = _.get(formBuilder.schema, fieldId);
    const xs = formSchema.xs ? formSchema.xs : null;
    const md = formSchema.md ? formSchema.md : null;

    const checkboxElements = this._getCheckboxElements();
    _.forIn(checkboxElements, (el, index) => {
      checkboxCols.push(
        <Col xs={xs} md={md}>
          {el}
        </Col>
      );
    });
    return checkboxCols;
  }

  _handleChange(value) {
    let currentValue = this.state.currentValue;
    if (currentValue.includes(value)) {
      _.pull(currentValue, value);
    }
    else {
      currentValue.push(value);
    }
    this.setState({currentValue});
  }

  getResult() {
    if (!_.isEqual(this.state.currentValue, this.props.initialValue)) {
      let result = {}
      const newValue = this.state.currentValue.length > 0 ? this.state.currentValue : [' ']
      result[this.props.submitKey] = newValue;
      return result;
    }
    return null;
  }
}
