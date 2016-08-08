'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormFieldImage from '../../../lib/forms/FormFields/FormFieldImage'
import FormFieldNested from '../../../lib/forms/FormFields/FormFieldNested'

import Col from 'react-bootstrap/lib/Col';
import Image from 'react-bootstrap/lib/Image';


export default class ShowFormImages extends React.Component {
  static propTypes = {
    images: PropTypes.array.isRequired
  };

  constructor(props) {
    super(props);

    this.state = {
      images: props.images.map((img) => {
        return img.image.smaller.url;
      })
    }
    _.bindAll(this, ['_onDataArrayChanged', '_handleImageChange'])
  }

  render() {
    return(
      <FormFieldNested
        ref='images_attributes'
        submitKey='images_attributes'
        label='Imágenes'
        initialDataArray={this.props.images}
        onDataArrayChanged={this._onDataArrayChanged}
        dataKeys={['image']}
        xs={12}
        md={6}
        lg={6}
        getRowCols={(img, index) => {

          const imageSource = this.state.images[index] ? this.state.images[index] :
            '/uploads/default_images/default.png';

          return([
              <Col md={2}>
                <Image
                  style={{width: 80, height: 100, "objectFit": 'cover'}}
                  src={`http://cinehorarios.cl${imageSource}`}
                  responsive
                />
              </Col>
              ,
              <Col md={8}>
                <FormFieldImage
                  onChange={this._handleImageChange}
                  initialValue={`http://cinehorarios.cl${img.image.smaller.url}`}
                  ref={`image${index}`}
                />
              </Col>
            ]
          );
        }}
      />
    );
  }

  _handleImageChange(newImage, index) {
    let images = this.state.images;
    images[index] = newImage;
    this.setState({images});
  }

  _onDataArrayChanged(dataArray) {
    this.setState({
      images: dataArray.map((dataItem) => {
        if (dataItem.image) {
          return dataItem.image.smaller.url;
        }
        return null;
      })
    })
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