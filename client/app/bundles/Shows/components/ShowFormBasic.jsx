'use strict';

import React, { PropTypes } from 'react'

import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Image from 'react-bootstrap/lib/Image';

import FormBuilder from '../../../lib/forms/FormBuilder';

export default class ShowFormBasic extends React.Component {
  static propTypes = {
    formBuilder: PropTypes.instanceOf(FormBuilder)
  };

  render() {
    const formBuilder = this.props.formBuilder;

    return (
      <Grid>
        <Row>
          <Col md={8}>
            {formBuilder.getField('name')}
            {formBuilder.getField('name_original')}
            <Row>
              <Col xs={12} md={4}>
                {formBuilder.getField('year')}
              </Col>
              <Col xs={12} md={4}>
                {formBuilder.getField('duration')}
              </Col>
              <Col xs={12} md={4}>
                {formBuilder.getField('debut')}
              </Col>
            </Row>
            {formBuilder.getField('information')}
            <Row>
              <Col md={8} lg={9}>
                {formBuilder.getField('imdb_code')}
              </Col>
              <Col md={4} lg={3}>
                {formBuilder.getField('imdb_score')}
              </Col>
            </Row>

            <Row>
              <Col md={8} lg={9}>
                {formBuilder.getField('metacritic_url')}
              </Col>
              <Col md={4} lg={3}>
                {formBuilder.getField('metacritic_score')}
              </Col>
            </Row>

            <Row>
              <Col md={8} lg={9}>
                {formBuilder.getField('rotten_tomatoes_url')}
              </Col>
              <Col md={4} lg={3}>
                {formBuilder.getField('rotten_tomatoes_score')}
              </Col>
            </Row>

          </Col>

          <Col md={4}>
            <Row>
              <Col xs={6} md={6}>
                {formBuilder.getField('genres')}
              </Col>
              <Col xs={6} md={6}>
                {formBuilder.getField('active')}
                {formBuilder.getField('rating')}
              </Col>
            </Row>
          </Col>
        </Row>
      </Grid>
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
