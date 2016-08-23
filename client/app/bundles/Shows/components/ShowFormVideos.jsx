'use strict';

import React, { PropTypes } from 'react'
import update from 'react/lib/update';
import _ from 'lodash'

import FormFieldImage from '../../../lib/forms/FormFields/FormFieldImage'
import FormFieldNested from '../../../lib/forms/FormFields/FormFieldNested'
import FormFieldText from '../../../lib/forms/FormFields/FormFieldText'
import FormFieldSelect from '../../../lib/forms/FormFields/FormFieldSelect'

import Row from 'react-bootstrap/lib/Col';
import Col from 'react-bootstrap/lib/Col';
import Image from 'react-bootstrap/lib/Image';


export default class ShowFormVideos extends React.Component {
  static propTypes = {
    videos: PropTypes.array.isRequired,
    videoTypes: PropTypes.array.isRequired,
  };

  constructor(props) {
    super(props);
    this.state = {
      images: props.videos.map((video) => {
        return video.image.image.smaller.url;
      })
    }
    _.bindAll(this, ['_onAddItem', '_onDeleteItem'])
  }

  render() {
    return(
      <FormFieldNested
        ref='videos_attributes'
        submitKey='videos_attributes'
        label='Videos'
        initialDataArray={this.props.videos}
        onAddItem={this._onAddItem}
        onDeleteItem={this._onDeleteItem}
        dataKeys={['name', 'code', 'video_type', 'outstanding']}
        xs={12}
        md={6}
        lg={6}
        getRowCols={(video, index) => {

          return([
              <Col md={3}>
                <Image
                  style={{height: 100, "objectFit": 'cover'}}
                  src={this.state.images[index]}
                  responsive
                />
              </Col>
              ,
              <Col md={7}>
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
                <FormFieldSelect
                  submitKey='video_type'
                  label='Video Type'
                  ref={`video_type${index}`}
                  initialValue={{
                    value: video.video_type,
                    label: video.video_type
                  }}
                  options={this.props.videoTypes}
                  async={false}
                />
              </Col>
            ]
          );
        }}
      />
    );
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