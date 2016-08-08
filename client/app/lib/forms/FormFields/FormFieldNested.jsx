'use strict'

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormGroup from 'react-bootstrap/lib/FormGroup'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import PageHeader from 'react-bootstrap/lib/PageHeader';
import Button from 'react-bootstrap/lib/Button'
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

export default class FormFieldNested extends React.Component {
  static propTypes = {
    submitKey: PropTypes.string,
    label: PropTypes.string,
    initialDataArray: PropTypes.array,
    onDataArrayChanged: PropTypes.func,
    getRowCols: PropTypes.func,
    dataKeys: PropTypes.array,
    xs: PropTypes.number,
    md: PropTypes.number,
    lg: PropTypes.number,
  };

  constructor(props) {
    super(props);
    this.state = {
      dataArray: props.initialDataArray.map((value) => {
        return {
          ...value,
          _destroy: false
        };
      })
    };
    _.bindAll(this, '_onAddRow');
  }

  render() {
    return(
      <div>
        <FormGroup controlId={this.props.submitKey}>
          <Row>
            {this._getRows()}
          </Row>
        </FormGroup>
        <br />
        <Button onClick={this._onAddRow} bsStyle="success">
          Nuevo
        </Button>
      </div>
    );
  }

  _getRows() {
    return this.state.dataArray.map((dataItem, index) => {
      if (!dataItem._destroy) {
        let rowCols = this.props.getRowCols(dataItem, index);
        rowCols.push(
          <Col md={1}>
            <Button
              style={{marginTop: 24}}
              bsStyle="danger"
              onClick={() => this._handleDelete(index)}
            >
              Borrar
            </Button>
          </Col>
        );
        return(
          <Col
            xs={this.props.xs ? this.props.xs : 12} 
            md={this.props.md ? this.props.md : 12}
            lg={this.props.lg ? this.props.lg : 12}
          >
            <Row>
              {rowCols}
            </Row>
          </Col>
        );
      }
    });
  }

  _onAddRow() {
    let dataArray = this.state.dataArray;
    dataArray.push({_destroy: false});
    this.setState({dataArray});
    this.props.onDataArrayChanged(dataArray);
  }

  _handleDelete(index) {
    let dataArray = this.state.dataArray;
    let dataItem = dataArray[index];

    if (dataItem.id) {
      dataItem._destroy = true;
      dataArray[index] = {id: dataItem.id, _destroy: true};
    }
    else {
       _.pullAt(dataArray, [index]);
    }
    this.setState({dataArray});
    this.props.onDataArrayChanged(dataArray);
  }

  getResult() {
    let submitArray = [];

    this.state.dataArray.forEach((dataItem, index) => {
      if (dataItem._destroy) {
        submitArray.push(dataItem); //{id: dataItem.id, _destroy: true}
      }
      else {
        let submitItem = {};
        this.props.dataKeys.forEach((dataKey) => {
          const ref = `${dataKey}${index}`;
          const formElement = this.refs[ref];
          if (formElement && _.isFunction(formElement.getResult)) {
            const elementResult = formElement.getResult();
            _.merge(submitItem, elementResult);
          }
        });

        if (Object.keys(submitItem).length > 0) {
          if (dataItem.id) {
            _.merge(submitItem, {id: dataItem.id})
          }
          submitArray.push(submitItem);
        }
      }
    });

    if (submitArray.length > 0) {
      return {[this.props.submitKey]: submitArray};
    }
    else {
      return null;
    }
  }
}