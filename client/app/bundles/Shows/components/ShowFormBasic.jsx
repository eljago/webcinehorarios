'use strict';

import React, { PropTypes } from 'react'

import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

export default class ShowFormBasic extends React.Component {
  static propTypes = {
    formBuilder: PropTypes.object,
    show: PropTypes.object,
  };

  render() {
    const {show, formBuilder} = this.props;
    if (show) {
      const modalTitle = show ? show.name : "Crear Show"

      return (
        <Row>
          <Col md={8}>
            {formBuilder.getFormField(show, 'name')}

            <Row>
              <Col xs={12} md={8} lg={9}>
                {formBuilder.getFormField(show, 'remote_image_url')}
              </Col>
              <Col xs={12} md={4} lg={3}>
                {formBuilder.getFormField(show, 'image')}
              </Col>
            </Row>

            {formBuilder.getFormField(show, 'information')}

            <Row>
              <Col md={8} lg={9}>
                {formBuilder.getFormField(show, 'imdb_code')}
              </Col>
              <Col md={4} lg={3}>
                {formBuilder.getFormField(show, 'imdb_score')}
              </Col>
            </Row>

            <Row>
              <Col md={8} lg={9}>
                {formBuilder.getFormField(show, 'metacritic_url')}
              </Col>
              <Col md={4} lg={3}>
                {formBuilder.getFormField(show, 'metacritic_score')}
              </Col>
            </Row>

            <Row>
              <Col md={8} lg={9}>
                {formBuilder.getFormField(show, 'rotten_tomatoes_url')}
              </Col>
              <Col md={4} lg={3}>
                {formBuilder.getFormField(show, 'rotten_tomatoes_score')}
              </Col>
            </Row>

          </Col>

          <Col md={4}>
            {formBuilder.getFormField(show, 'debut')}

            <Row>
              <Col xs={3} md={12}>
                {formBuilder.getFormField(show, 'rating')}
              </Col>
              <Col xs={9} md={12}>
                {formBuilder.getFormField(show, 'genres')}
              </Col>
            </Row>

          </Col>
        </Row>
      );
    }
    else {
      return null;
    }
  }

  getResult() {
    let showResult = {};
    _.forIn(this.refs, (formElement, key) => {
      if (_.isFunction(formElement.getResult)) {
        _.merge(showResult, formElement.getResult());
      }
    });
    return showResult;
  }
}
