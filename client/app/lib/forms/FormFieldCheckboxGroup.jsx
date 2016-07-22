'use strict';

import React, { PropTypes } from 'react'
import {Checkbox, ControlLabel, FormGroup, Row, Col} from 'react-bootstrap'
import _ from 'lodash'

export default class FormFieldCheckboxGroup extends React.Component {
  static propTypes = {
    controlId: PropTypes.string,
    onChange: PropTypes.func,
    label: PropTypes.string,
    options: PropTypes.array.isRequired,
    selectedValues: PropTypes.array,
    columns: PropTypes.number,
  };
  static defaultProps = {
    label: '',
    columns: 1,
  };

  constructor(props) {
    super(props)
    this.state = {
      selectedValues: props.selectedValues
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
          checked={this.state.selectedValues.includes(opt.value)}
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
    let selectedValues = this.state.selectedValues;
    if (selectedValues.includes(value)) {
      _.pull(selectedValues, value);
    }
    else {
      selectedValues.push(value);
    }
    this.setState({selectedValues});
    const {controlId, onChange} = this.props;
    onChange(controlId, selectedValues);
    console.log(selectedValues);
    console.log(value);
  }
}
