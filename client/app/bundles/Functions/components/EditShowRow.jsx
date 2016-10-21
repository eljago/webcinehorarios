'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormBuilder from '../../../lib/forms/FormBuilder';

import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

export default class EditFormRow extends React.Component {

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
      <tr>
        <td>
          <img src={`http://cinehorarios.cl${show.image_url}`} />
        </td>
        <td>
          {formBuilder.getField('functions', {
            getContentRow: this._getContentRow
          })}
        </td>
      </tr>
    );
  }

  _getContentRow(func, index) {
    const formBuilder = this.props.formBuilder;
    return(
      <Row key={func.id ? func.id : func.key}>
        <Col xs={12} md={5}>
          {formBuilder.getNestedField('functions', 'function_types', index, {
            columns: 3
          })}
        </Col>
        <Col xs={12} md={7}>
          {formBuilder.getNestedField('functions', 'showtimes', index)}
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