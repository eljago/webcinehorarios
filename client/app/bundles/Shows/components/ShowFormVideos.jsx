'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormFieldImage from '../../../lib/forms/FormFields/FormFieldImage'
import FormFieldNested from '../../../lib/forms/FormFields/FormFieldNested'
import FormFieldText from '../../../lib/forms/FormFields/FormFieldText'

import Row from 'react-bootstrap/lib/Col';
import Col from 'react-bootstrap/lib/Col';
import Image from 'react-bootstrap/lib/Image';


export default class ShowFormVideos extends React.Component {
  static propTypes = {
    videos: PropTypes.array.isRequired
  };

  constructor(props) {
    super(props);
    this.state = {
      images: props.videos.map((video) => {
        return video.image.image.smaller.url;
      })
    }
    _.bindAll(this, ['_onDataArrayChanged'])
  }

  render() {
    return(
      <FormFieldNested
        ref='videos_attributes'
        submitKey='videos_attributes'
        label='Videos'
        initialDataArray={this.props.videos}
        onDataArrayChanged={this._onDataArrayChanged}
        dataKeys={['name', 'code', 'video_type', 'outstanding']}
        xs={12}
        md={6}
        lg={6}
        getRowCols={(video, index) => {

          const imageSource = this.state.images[index] ? this.state.images[index] :
            '/uploads/default_images/default.png';

          return([
              <Col md={2}>
                <Image
                  style={{width: 80, height: 100, "objectFit": 'cover'}}
                  src={imageSource}
                  responsive
                />
              </Col>
              ,
              <Col md={8}>
                <FormFieldText
                  submitKey='name'
                  label='Nombre'
                  ref={`name${index}`}
                  initialValue={video.name}
                />
                <FormFieldText
                  submitKey='code'
                  label='Código'
                  ref={`code${index}`}
                  initialValue={video.code}
                />
              </Col>
            ]
          );
        }}
      />
    );
  }

  _onDataArrayChanged(dataArray) {
    this.setState({
      images: dataArray.map((dataItem) => {
        if (dataItem.image) {
          return dataItem.image.image.smaller.url;
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