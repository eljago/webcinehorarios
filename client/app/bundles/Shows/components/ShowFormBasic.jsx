'use strict';

import React, { PropTypes } from 'react'

import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Image from 'react-bootstrap/lib/Image';


import FormBuilderShow from '../../../lib/forms/FormBuilders/FormBuilderShow'

export default class ShowFormBasic extends React.Component {
  static propTypes = {
    formBuilder: PropTypes.instanceOf(FormBuilderShow)
  };

  constructor(props) {
    super(props);
    this.state = {
      thumbSource: ''
    }
    _.bindAll(this, '_setThumbSource');
  }

  render() {
    const formBuilder = this.props.formBuilder;

    if (formBuilder) {
      return (
        <Row>
          <Col md={8}>
            {formBuilder.getFormField('name')}
            <Row>
              <Col xs={12} md={4}>
                <Image src={this.state.thumbSource} responsive/>
              </Col>
              <Col xs={12} md={8}>
                {formBuilder.getFormField('image', {setThumbSource: this._setThumbSource})}
                {formBuilder.getFormField('information')}
              </Col>
            </Row>

            <Row>
              <Col md={8} lg={9}>
                {formBuilder.getFormField('imdb_code')}
              </Col>
              <Col md={4} lg={3}>
                {formBuilder.getFormField('imdb_score')}
              </Col>
            </Row>

            <Row>
              <Col md={8} lg={9}>
                {formBuilder.getFormField('metacritic_url')}
              </Col>
              <Col md={4} lg={3}>
                {formBuilder.getFormField('metacritic_score')}
              </Col>
            </Row>

            <Row>
              <Col md={8} lg={9}>
                {formBuilder.getFormField('rotten_tomatoes_url')}
              </Col>
              <Col md={4} lg={3}>
                {formBuilder.getFormField('rotten_tomatoes_score')}
              </Col>
            </Row>

          </Col>

          <Col md={4}>
            {formBuilder.getFormField('debut')}

            <Row>
              <Col xs={3} md={12}>
                {formBuilder.getFormField('rating')}
              </Col>
              <Col xs={9} md={12}>
                {formBuilder.getFormField('genres')}
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

  _setThumbSource(thumbSource) {
    this.setState({thumbSource: thumbSource})
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
