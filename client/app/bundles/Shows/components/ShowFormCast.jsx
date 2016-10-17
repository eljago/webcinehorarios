'use strict';

import React, { PropTypes } from 'react';
import update from 'react/lib/update';
import _ from 'lodash';

import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Image from 'react-bootstrap/lib/Image';

import FormBuilder from '../../../lib/forms/FormBuilder';

export default class FormCast extends React.Component {
  static propTypes = {
    formBuilder: PropTypes.instanceOf(FormBuilder),
    images: PropTypes.array,
  };

  constructor(props) {
    super(props);
    this.state = {
      images: props.formBuilder.object.show_person_roles.map((spr) => {
        return spr.image.smallest.url;
      })
    }
    _.bindAll(this, ['_onAddItem', '_onDeleteItem', '_getContentRow'])
  }

  render() {
    return(
      <div>
        {this.props.formBuilder.getField('show_person_roles', {
          onAddItem: this._onAddItem,
          onDeleteItem: this._onDeleteItem,
          getContentRow: this._getContentRow
        })}
      </div>
    );
  }

  _getContentRow(index) {
    return(
      <Row>
        <Col xs={12} md={2}>
          <Image
            style={{width: 80, height: 100, "objectFit": 'cover'}}
            src={this.state.images[index]}
            responsive
          />
        </Col>
        <Col xs={12} md={4}>
          {this.props.formBuilder.getNestedField('show_person_roles', 'person_id', index, {
            getInitialValue: (obj) => {
              return {value: obj.person_id, label: obj.name};
            },
            onChange: (newValue) => {this._onChangeSelect(newValue, index)}
          })}
        </Col>
        <Col xs={12} md={4}>
          {this.props.formBuilder.getNestedField('show_person_roles', 'character', index)}
        </Col>
        <Col xs={6} md={1}>
          {this.props.formBuilder.getNestedField('show_person_roles', 'actor', index)}
        </Col>
        <Col xs={6} md={1}>
          {this.props.formBuilder.getNestedField('show_person_roles', 'director', index)}
        </Col>
      </Row>
    );
  }

  _onChangeSelect(value, index) {
    this.setState({
      images: update(this.state.images, {[index]: {$set: value.image_url}})
    });
  }

  _onAddItem(newItem) {
    this.setState({
      images: update(this.state.images, {$push: ['/uploads/default_images/default.png']})
    });
  }

  _onDeleteItem(index) {
    this.setState({
      images: update(this.state.images, {$splice: [[index, 1]]})
    });
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