'use strict'

import React, { PropTypes } from 'react'
import update from 'react/lib/update';
import _ from 'lodash'

import FormGroup from 'react-bootstrap/lib/FormGroup'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import PageHeader from 'react-bootstrap/lib/PageHeader';
import Button from 'react-bootstrap/lib/Button'
import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

export default class FormFieldNested extends React.Component {
  static propTypes = {
    submitKey: PropTypes.string,
    label: PropTypes.string,
    initialValue: PropTypes.array,
    onAddItem: PropTypes.func,
    onDeleteItem: PropTypes.func,
    getContentRow: PropTypes.func,
    dataKeys: PropTypes.array,
    xs: PropTypes.number,
    md: PropTypes.number,
    lg: PropTypes.number,
  };

  constructor(props) {
    super(props);
    this.state = {
      dataArray: props.initialValue.map((value) => {
        return {
          id: value.id,
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
        return(
          <Col
            xs={this.props.xs ? this.props.xs : 12} 
            md={this.props.md ? this.props.md : 12}
            lg={this.props.lg ? this.props.lg : 12}
          >
            <Row>
              <Col xs={12} md={9} lg={10}>
                {this.props.getContentRow(dataItem, index)}
              </Col>
              <Col xs={12} md={3} lg={2}>
                <Button
                  style={{marginTop: 24, marginBottom: 24}}
                  bsStyle="danger"
                  onClick={() => this._handleDelete(index)}
                  block
                >
                  Borrar
                </Button>
              </Col>
            </Row>
          </Col>
        );
      }
    });
  }

  _onAddRow() {
    const dataArray = update(this.state.dataArray, {$push: [{
      "_destroy": false,
      key: (new Date()).getTime()
    }]});
    if (this.props.onAddItem) {
      this.props.onAddItem(dataArray);
    }
    this.setState({dataArray})
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
    if (this.props.onDeleteItem) {
      this.props.onDeleteItem(index);
    }
  }

  getResult() {
    let submitArray = [];

    this.state.dataArray.forEach((dataItem, index) => {
      if (dataItem._destroy) {
        submitArray.push(dataItem); //{id: dataItem.id, _destroy: true}
      }
      else {
        let submitItem = {};

        // Loop form keys to find each form element by their ref
        this.props.dataKeys.forEach((dataKey) => {
          const ref = `${dataKey}${index}`;
          const formElement = this.refs[ref];
          if (formElement && _.isFunction(formElement.getResult)) {
            const elementResult = formElement.getResult();
            _.merge(submitItem, elementResult);
          }
        });

        // if it's an existing record, add the id to the submit data:
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