'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';

import FormControl from 'react-bootstrap/lib/FormControl';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import FormGroup from 'react-bootstrap/lib/FormGroup';
import Image from 'react-bootstrap/lib/Image';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

import Select from 'react-select';

import FormBuilder from '../FormBuilders/FormBuilder'

export default class FormFieldSelect extends React.Component {
  static propTypes = {
    fieldId: PropTypes.string,
    formBuilder: PropTypes.instanceOf(FormBuilder),
    submitKey: PropTypes.number,
    label: PropTypes.string,
    keyName: PropTypes.string,
    getOptions: PropTypes.array,
    initialValue: PropTypes.object,
  };
  static defaultProps = {
    label: '',
    initialValue: ''
  };

  constructor(props) {
    super(props)
    this.state = {
      currentValue: props.initialValue
    };
    _.bindAll(this, '_handleChange');
  }

  render() {
    return(
      <FormGroup controlId={this.props.submitKey}>
        <ControlLabel>{this.props.label}</ControlLabel>
        <Row>
          <Col md={2}>
            <Image
              src={this.state.currentValue.image_url}
              responsive
            />
          </Col>
          <Col md={10}>
            <Select.Async
              name={this.props.submitKey}
              value={this.state.currentValue}
              onChange={this._handleChange}
              loadOptions={this.props.getOptions}
              clearable={false}
            />
          </Col>
        </Row>
      </FormGroup>
    )
  }

  _handleChange(newValue) {
    this.setState({currentValue: newValue});
  }

  getResult() {
    const initialValue = this.props.initialValue;
    if (this.state.currentValue.value != initialValue.value) {
      let result = {}
      return {[this.props.keyName]: this.state.currentValue.value};
    }
    return null;
  }
}
