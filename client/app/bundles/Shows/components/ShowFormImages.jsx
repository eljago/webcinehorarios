'use strict';

import React, { PropTypes } from 'react'
import update from 'react/lib/update';
import _ from 'lodash'

import Carousel from '../../../lib/ReusableComponents/Carousel'

import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Image from 'react-bootstrap/lib/Image';
import Modal from 'react-bootstrap/lib/Modal';
import Button from 'react-bootstrap/lib/Button';

import FormBuilder from '../../../lib/forms/FormBuilder';

export default class ShowFormImages extends React.Component {
  static propTypes = {
    formBuilder: PropTypes.instanceOf(FormBuilder),
    images: PropTypes.array.isRequired
  };

  constructor(props) {
    super(props);
    this.state = {
      images: props.formBuilder.object.images.map((img) => {
        return img.image.smaller.url;
      }),
      lgShow: false,
      modalIndex: 0,
    }
    _.bindAll(this, ['_onAddItem', '_onDeleteItem', '_getContentRow'])
  }

  render() {
    let lgClose = () => this.setState({ lgShow: false });
    return(
      <div>
        {this.props.formBuilder.getField('images', {
          onAddItem: this._onAddItem,
          onDeleteItem: this._onDeleteItem,
          getContentRow: this._getContentRow
        })}
        <Modal show={this.state.lgShow} onHide={lgClose} bsSize="large">
          <Modal.Body>
            <Carousel
              initialIndex={this.state.modalIndex}
              images={this.state.images}
            />
          </Modal.Body>
        </Modal>
      </div>
    );
  }

  _getContentRow(image, index) {
    return(
      <Row>
        <Col xs={12} sm={2}>
          <Button style={{padding: 3}} onClick={()=> {
            this.setState({
              lgShow: true,
              modalIndex: index,
              padding: 0,
            })
          }}>
            <Image
              style={{width: 50, height: 50, "objectFit": 'cover'}}
              src={this.state.images[index]}
              responsive
            />
          </Button>
        </Col>
        <Col xs={12} sm={2}>
          {this.props.formBuilder.getNestedField('images', 'backdrop', index)}
        </Col>
        <Col xs={12} sm={2}>
          {this.props.formBuilder.getNestedField('images', 'poster', index)}
        </Col>
        <Col xs={12} sm={6}>
          {this.props.formBuilder.getNestedField('images', 'image', index, {
            horizontal: true,
            getInitialValue: (obj) => {
              return obj.image.small.url;
            },
            onChange: (newImage) => {this._handleImageChange(newImage, index)}
          })}
        </Col>
      </Row>
    );
  }

  _handleImageChange(newImage, index) {
    this.setState({
      images: update(this.state.images, {[index]: {$set: newImage}})
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
