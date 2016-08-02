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
    fieldId: PropTypes.string,
    formBuilder: PropTypes.instanceOf(FormBuilder),
    submitKey: PropTypes.string,
    label: PropTypes.string,
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
    _.bindAll(this, '_onAddRow');
  }

  render() {
    return(
      <div>
        <FormGroup controlId={this.props.submitKey}>
          <Row>
            {this._getRowFields()}
          </Row>
        </FormGroup>
        <br />
        <Button onClick={this._onAddRow} bsStyle="success">
          Nuevo
        </Button>
      </div>
    );
  }

  _getRowFields() {
    const {fieldId, formBuilder} = this.props;
    const formSchema = _.get(formBuilder.schema, fieldId);
    let rowsFields = [];

    const columnsKeys = this._getColumnsKeys()
    this.state.rowsStatus.forEach((rowData, index) => {
      if (rowData.get('_destroy')) {

      }
      else {
        let columnFields = columnsKeys.map((key) => {
          const schemaPath = this._getFieldSchema(key);
          const fieldSchema = formSchema.subFields[key];
          const xs = fieldSchema.xs ? fieldSchema.xs : null;
          const md = fieldSchema.md ? fieldSchema.md : null;
          return (
            <Col xs={xs} md={md}>
              {formBuilder.getFormField(schemaPath, {index: index})}
            </Col>
          );
        });
        // Delete Button
        columnFields.push(
          <Button
            style={{marginTop: 24}}
            bsStyle="danger"
            onClick={() => this._handleDelete(index)}
          >
            Borrar
          </Button>
        );
        // Add Row
        const xs = formSchema.xs ? formSchema.xs : null;
        const md = formSchema.md ? formSchema.md : null;
        rowsFields.push(
          <Col xs={xs} md={md}>
            <Row key={index}>{columnFields}</Row>
          </Col>
        );
      }
    });

    return rowsFields;
  }

  _onAddRow() {
    const newRowStatus = Immutable.fromJS({_destroy: false});
    const rowsStatus = this.state.rowsStatus.push(newRowStatus);
    this.setState({rowsStatus});
  }

  _handleDelete(index) {
    const fieldId = this.props.fieldId;
    let rowsStatus = this.state.rowsStatus;
    let rowData = rowsStatus.get(index);

    if (rowData.get('id')) {
      rowData = rowData.set('_destroy', true);

      const columnsKeys = this._getColumnsKeys()
      // ["character", "actor", "director", etc]

      _.forIn(columnsKeys, (key) => {
        const formElement = this._getFormElement(key, index);
        if (formElement && _.isFunction(formElement.getResult)) {
          const columnResult = formElement.getResult();
          rowData = rowData.merge(columnResult);
        }
      });
      rowsStatus = rowsStatus.set(index, rowData);
      this.setState({rowsStatus});
    }
    else {
      rowsStatus = rowsStatus.delete(index);
    }
    this.setState({rowsStatus});
  }

  _getColumnsKeys() {
    return Object.keys(this.props.formBuilder.schema[this.props.fieldId].subFields)
  }

  _getFieldSchema(key) {
    return `${this.props.fieldId}.subFields.${key}`;
  }

  _getFormElement(key, index) {
    const {fieldId, formBuilder} = this.props;

    const schemaPath = this._getFieldSchema(key);
    let initialValuePath = _.get(formBuilder.schema, schemaPath).initialValuePath;
    const ref = initialValuePath.replace(/\[\]/, `[${index}]`);
    return this.refs[ref];
  }

  getResult() {
    let rowsArray = [];

    this.state.rowsStatus.forEach((rowData, index) => {
      const columnsKeys = this._getColumnsKeys()

      let rowResult = {};

      // if _destroy it's true, I don't care about setting the form values
      if (rowData.get('_destroy')) {
        _.merge(rowResult, rowData.toJS());
      }
      else {
        _.forIn(columnsKeys, (key) => {
          const formElement = this._getFormElement(key, index);
          if (formElement && _.isFunction(formElement.getResult)) {
            const columnResult = formElement.getResult();
            _.merge(rowResult, columnResult);
          }
        });
      }
      // If this rows had changed, add it to the RowsArray that will be submitted
      if (Object.keys(rowResult).length > 0) {
        _.merge(rowResult, rowData.toJS());
        rowsArray.push(rowResult);
      }
    })
    if (rowsArray.length > 0) {
      return {[this.props.submitKey]: rowsArray};
    }
    else {
      return null;
    }
  }
}
