'use strict'

import React, { PropTypes } from 'react'
import Immutable from 'immutable'
import _ from 'lodash'

import FormGroup from 'react-bootstrap/lib/FormGroup'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import Button from 'react-bootstrap/lib/Button'
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
    const {formBuilder, fieldId} = props;
    this.state = {
      rowsStatus: Immutable.fromJS(formBuilder.object[fieldId].map((value, index) => {
        return {
          id: value.id,
          person_id: value.person_id,
          position: index,
          _destroy: false
        };
      }))
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

  _handleDelete(rowIndex) {
    const fieldId = this.props.fieldId;
    let rowsStatus = this.state.rowsStatus;
    let rowData = rowsStatus.get(rowIndex);
    if (rowData.get('id')) {
      rowData = rowData.set('_destroy', true);

      const columnsKeys = this._getColumnsKeys()

      _.forIn(columnsKeys, (key) => {
        const ref = `${fieldId}${rowIndex}${key}`;
        const formElement = this.refs[ref];
        if (formElement && _.isFunction(formElement.getResult)) {
          const columnResult = formElement.getResult();
          rowData = rowData.merge(columnResult);
        }
      });
      rowsStatus = rowsStatus.set(rowIndex, rowData);
      this.setState({rowsStatus});
    }
    else {
      rowsStatus = rowsStatus.delete(rowIndex);
    }
    this.setState(rowsStatus);
  }

  _getRowFields() {
    const {fieldId, formBuilder} = this.props;

    const columnsKeys = this._getColumnsKeys()
    // ["character", "actor", "director", etc]

    const rowsStatus = this.state.rowsStatus;
    const object = formBuilder.object;

    let rowsFields = [];

    rowsStatus.forEach((rowData, index) => {
      if (rowData.get('_destroy')) {

      }
      else {
        let columnFields = columnsKeys.map((subFieldId) => {
          const schemaPath = `${fieldId}.subFields.${subFieldId}`;
          const objectPath = `${fieldId}[${index}].${subFieldId}`;

          return (
            <Col xs={2}>
              {formBuilder.getFormField(schemaPath, objectPath)}
            </Col>
          );
        });
        columnFields.push(
          <Button
            bsStyle="danger"
            onClick={() => this._handleDelete(index)}
          >
            Borrar
          </Button>
        );
        rowsFields.push(
          <Row key={index}>{columnFields}</Row>
        );
      }
    });

    return rowsFields;
  }

  getResult() {
    const {fieldId, formBuilder, submitKey} = this.props;

    let rowsArray = [];
    this.state.rowsStatus.forEach((rowData, index) => {
      const columnsKeys = this._getColumnsKeys()
      let rowResult = rowData;
      _.forIn(columnsKeys, (key) => {
        // ref is set in FormBuilder with this same format:
        const ref = `${fieldId}${index}${key}`;
        const formElement = this.refs[ref];
        if (formElement && _.isFunction(formElement.getResult)) {
          const columnResult = formElement.getResult();
          rowResult = _.merge(rowResult, columnResult);
        }
      });
      if (Object.keys(rowResult).length > 0) {
        rowsArray.push(rowResult);
      }
    })
    const result = {[submitKey]: rowsArray};
    return result;
  }

  _getColumnsKeys() {
    return Object.keys(this.props.formBuilder.schema[this.props.fieldId].subFields)
  }
}
