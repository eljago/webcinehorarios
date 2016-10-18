'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormBuilder from '../../../lib/forms/FormBuilder';

import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

export default class FormRow extends React.Component {

  static propTypes = {
    formBuilder: PropTypes.instanceOf(FormBuilder),
  };

  constructor(props) {
    super(props);
    _.bindAll(this, '_getContentRow');
  }

  render() {
    const formBuilder = this.props.formBuilder;
    const show = formBuilder.object;
    return(
      <Row>
        <Col xs={12} sm={2}>
          <img src={`http://cinehorarios.cl${show.image_url}`} />
        </Col>
        <Col xs={12} sm={10}>
          {formBuilder.getField('functions', {
            getContentRow: this._getContentRow
          })}
        </Col>
      </Row>
    );
  }

  _getContentRow(index) {
    return(
      <Row>
        <Col xs={12} md={5}>
          {this.props.formBuilder.getNestedField('functions', 'function_types', index, {
            columns: 5
          })}
        </Col>
        <Col xs={12} md={7}>
          {this.props.formBuilder.getNestedField('functions', 'showtimes', index)}
        </Col>
      </Row>
    );
  }

  getResult() {
    let showResult = {};
    _.forIn(this.refs, (formElement) => {
      if (_.isFunction(formElement.getResult)) {
        _.merge(showResult, formElement.getResult());
      }
    });
    return showResult;
  }
}