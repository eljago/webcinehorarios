'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import ErrorMessages from '../../../lib/forms/FormFields/ErrorMessages'

import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

import FormBuilder from '../../../lib/forms/FormBuilder';

export default class FunctionForm extends React.Component {

  static propTypes = {
    formBuilder: PropTypes.instanceOf(FormBuilder),
    errors: PropTypes.object,
    submitting: PropTypes.boolean,
  };

  render() {
    const {formBuilder, errors, submitting} = this.props;
    const show = formBuilder.object.show;
    return(
      <form>
        <ErrorMessages errors={errors} />
        <Grid>
          <Row>
            <Col>
              {formBuilder.getField('show_id', {
                initialValue: {value: show.id, label: show.name}
              })}
            </Col>
          </Row>
          <Row>
            <Col xs={12} sm={3}>
              {formBuilder.getField('function_types')}
            </Col>
            <Col xs={12} sm={9}>
              {formBuilder.getField('showtimes', {placeholder: 'Showtimes'})}
            </Col>
          </Row>
        </Grid>
        {formBuilder.getSubmitButton({disabled: submitting})}
      </form>
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