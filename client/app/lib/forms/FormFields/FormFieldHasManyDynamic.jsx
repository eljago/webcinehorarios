'use strict'

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormGroup from 'react-bootstrap/lib/FormGroup'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

import FormBuilder from '../FormBuilders/FormBuilder'

export default class FormFieldHasManyDynamic extends React.Component {
  static propTypes = {
    submitKey: PropTypes.string,
    label: PropTypes.string,
    fieldId: PropTypes.string,
    formBuilder: PropTypes.instanceOf(FormBuilder),
  };

  constructor(props) {
    super(props);
    this.state = {
      fieldsStatus: props.formBuilder.object[props.fieldId].map((value, index) => {
        return {
          index: index,
          type: 'initialField'
        };
      })
    };
  }

  render() {
    return(
      <FormGroup controlId={this.props.submitKey}>
        <ControlLabel>{this.props.label}</ControlLabel>
        {this._getRowFields()}
      </FormGroup>
    );
  }

  _getRowFields() {
    const formBuilder = this.props.formBuilder;
    const fieldId = this.props.fieldId;
    const subFieldsIds = Object.keys(formBuilder.schema[fieldId].subFields);
    const rowFields = formBuilder.object[fieldId].map((value, index1) => {
      return subFieldsIds.map((subFieldId, index2) => {
        const schemaPath = `${fieldId}.subFields.${subFieldId}`;
        const objectPath = `${fieldId}[${index1}].${subFieldId}`;
        return(
          <Col xs={3}>
            {formBuilder.getFormField(schemaPath, objectPath)}
          </Col>
        );
      });
    });
    return(
      <Row>
        {rowFields}
      </Row>
    );
  }

  // getResult() {
  //   if (!_.isEmpty(this.state.currentValue)) {
  //     let result = {}
  //     result[this.props.submitKey] = this.state.currentValue;
  //     return result;
  //   }
  //   return null;
  // }
}
