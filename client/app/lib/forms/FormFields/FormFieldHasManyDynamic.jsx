'use strict'

import React, { PropTypes } from 'react'
import Immutable from 'immutable'
import _ from 'lodash'

import FormGroup from 'react-bootstrap/lib/FormGroup'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import PageHeader from 'react-bootstrap/lib/PageHeader';
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
          _destroy: false
        };
      }))
    };
  }

  render() {
    return(
      <FormGroup controlId={this.props.submitKey}>
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
    const schema = formBuilder.schema;

    let rowsFields = [];

    rowsStatus.forEach((rowData, index) => {
      if (rowData.get('_destroy')) {

      }
      else {
        let columnFields = columnsKeys.map((key) => {
          const schemaPath = `${fieldId}.subFields.${key}`;
          const colValue = _.get(schema, schemaPath).col;
          return (
            <Col xs={colValue ? colValue : 2}>
              {formBuilder.getFormField(schemaPath, index)}
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

      let rowResult = {};

      // if _destroy it's true, I don't care about setting the form values
      if (!rowData.get('_destroy')) {
        _.forIn(columnsKeys, (key) => {
          const schemaPath = `${fieldId}.subFields.${key}`;
          let initialValuePath = _.get(formBuilder.schema, schemaPath).initialValuePath;
          const ref = initialValuePath.replace(/\[\]/, `[${index}]`);
          const formElement = this.refs[ref];
          if (formElement && _.isFunction(formElement.getResult)) {
            const columnResult = formElement.getResult();
            _.merge(rowResult, columnResult);
          }
        });
      }
      else {

      }
      if (Object.keys(rowResult).length > 0) {
        _.merge(rowResult, rowData.toJS());
        rowsArray.push(rowResult);
      }
    })
    if (rowsArray.length > 0) {
      return {[submitKey]: rowsArray};
    }
    else {
      return null;
    }
  }

  _getColumnsKeys() {
    return Object.keys(this.props.formBuilder.schema[this.props.fieldId].subFields)
  }
}
