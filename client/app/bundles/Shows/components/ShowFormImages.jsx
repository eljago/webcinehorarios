'use strict';

import React, { PropTypes } from 'react'
import update from 'react/lib/update';
import _ from 'lodash'

import FormFieldImage from '../../../lib/forms/FormFields/FormFieldImage'
import FormFieldNested from '../../../lib/forms/FormFields/FormFieldNested'
import Carousel from '../../../lib/ReusableComponents/Carousel'

import Col from 'react-bootstrap/lib/Col';
import Image from 'react-bootstrap/lib/Image';
import Tooltip from 'react-bootstrap/lib/Tooltip';
import Modal from 'react-bootstrap/lib/Modal';
import Button from 'react-bootstrap/lib/Button';


export default class ShowFormImages extends React.Component {
  static propTypes = {
    images: PropTypes.array.isRequired
  };

  constructor(props) {
    super(props);

    this.state = {
      images: props.images.map((img) => {
        return img.image.small.url;
      }),
      lgShow: false,
      modalIndex: 0,
    }
    _.bindAll(this, ['_onAddItem', '_onDeleteItem'])
  }

  render() {
    let lgClose = () => this.setState({ lgShow: false });
    return(
      <div>
        <FormFieldNested
          ref='images_attributes'
          submitKey='images_attributes'
          label='Imágenes'
          initialDataArray={this.props.images}
          onAddItem={this._onAddItem}
          onDeleteItem={this._onDeleteItem}
          dataKeys={['image']}
          xs={12}
          md={6}
          lg={6}
          getRowCols={(img, index) => {

            const initValue = img.image ? img.image.small.url : '/uploads/default_images/default.png';

            return([
                <Col md={4}>
                  <Button style={{padding: 3}} onClick={()=> {
                    this.setState({
                      lgShow: true,
                      modalIndex: index,
                      padding: 0,
                    })
                  }}>
                    <Image
                      style={{width: 100, height: 100, "objectFit": 'cover'}}
                      src={this.state.images[index]}
                      responsive
                    />
                  </Button>
                </Col>
                ,
                <Col md={6}>
                  <FormFieldImage
                    onChange={(newImage) => this._handleImageChange(newImage, index)}
                    initialValue={initValue}
                    ref={`image${index}`}
                  />
                </Col>
              ]
            );
          }}
        />
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