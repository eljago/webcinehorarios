'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Checkbox from 'react-bootstrap/lib/Checkbox';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import FormGroup from 'react-bootstrap/lib/FormGroup';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

export default class FormFieldCheckboxGroup extends React.Component {
  static propTypes = {
    controlId: PropTypes.string,
    label: PropTypes.string,
    options: PropTypes.array.isRequired,
    initialValue: PropTypes.array,
    columns: PropTypes.number,
  };
  static defaultProps = {
    label: '',
    columns: 1,
  };

  constructor(props) {
    super(props)
    this.state = {
      currentValue: [].concat(props.initialValue)
    };
    _.bindAll(this, [
      '_handleChange',
    ]);
  }

  render() {
    const {controlId, label} = this.props;

    return(
      <FormGroup controlId={controlId}>
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
    const {columns} = this.props;
    const checkboxElements = this._getCheckboxElements();
    const length = checkboxElements.length;
    let checkboxCols = [];
    for (var column = 0; column < columns; column++) {
      let innerElements = [];
      _.forIn(checkboxElements, (el, index) => {
        const elementsPerCol = _.floor(length/columns);
        if (index >= elementsPerCol * column && index < elementsPerCol * (column+1)) {
          innerElements.push(el)
        }
      });
      checkboxCols.push(
        <Col xs={12/columns}>
          {innerElements}
        </Col>
      );
    }
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
      result[this.props.controlId] = newValue;
      return result;
    }
    return null;
  }
}
