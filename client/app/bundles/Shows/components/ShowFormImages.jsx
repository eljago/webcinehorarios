'use strict';

import React, { PropTypes } from 'react'
import update from 'react/lib/update';
import _ from 'lodash'

import FormFieldImage from '../../../lib/forms/FormFields/FormFieldImage'
import FormFieldNested from '../../../lib/forms/FormFields/FormFieldNested'
import FormFieldCheckbox from '../../../lib/forms/FormFields/FormFieldCheckbox'
import Carousel from '../../../lib/ReusableComponents/Carousel'

import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Image from 'react-bootstrap/lib/Image';
import Tooltip from 'react-bootstrap/lib/Tooltip';
import Modal from 'react-bootstrap/lib/Modal';
import Button from 'react-bootstrap/lib/Button';


export default class ShowFormImages extends React.Component {
  static propTypes = {
    showId: PropTypes.number,
    images: PropTypes.array.isRequired
  };

  constructor(props) {
    super(props);
    let portraitIndex = -1;
    const images = props.images.map((img, index) => {
      if (img.show_portrait_id == props.showId) {
        portraitIndex = index;
      }
      return img.image.small.url;
    })
    this.state = {
      images: images,
      lgShow: false,
      modalIndex: 0,
      portraitIndex: portraitIndex,
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
          dataKeys={['image', 'show_portrait_id']}
          xs={12}
          md={6}
          lg={6}
          getContentRow={(img, index) => {

            return(
              <Row>
                <Col xs={12} md={6} lg={5}>
                  <Row>
                    <Col xs={10}>
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
                    <Col xs={2}>
                      <FormFieldCheckbox
                        submitKey='show_portrait_id'
                        ref={`show_portrait_id${index}`}
                        initialValue={this.props.showId ? img.show_portrait_id == this.props.showId : false}
                        getResultForValue={(value) => {
                          return value ? this.props.showId : null;
                        }}
                        onChange={(newValue) => {
                          this.refs.images_attributes.
                            refs[`show_portrait_id${this.state.portraitIndex}`].setValue(false);
                          this.refs.images_attributes.
                            refs[`show_portrait_id${index}`].setValue(true);
                          this.setState({
                            portraitIndex: newValue ? index : -1
                          });
                        }}
                      />
                    </Col>
                  </Row>
                </Col>
                <Col xs={12} md={6} lg={7}>
                  <FormFieldImage
                    onChange={(newImage) => this._handleImageChange(newImage, index)}
                    initialValue={img.image ? img.image.small.url : '/uploads/default_images/default.png'}
                    ref={`image${index}`}
                  />
                </Col>
              </Row>
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
