'use strict';

import React, { PropTypes } from 'react'
import update from 'react/lib/update';
import _ from 'lodash'

import Row from 'react-bootstrap/lib/Col';
import Col from 'react-bootstrap/lib/Col';
import Image from 'react-bootstrap/lib/Image';

import FormBuilder from '../../../lib/forms/FormBuilder';

export default class ShowFormVideos extends React.Component {
  static propTypes = {
    formBuilder: PropTypes.instanceOf(FormBuilder),
  };

  constructor(props) {
    super(props);
    this.state = {
      images: props.formBuilder.object.videos.map((video) => {
        return video.image.image.smaller.url;
      })
    }
    _.bindAll(this, ['_onAddItem', '_onDeleteItem', '_getContentRow'])
  }

  render() {
    return(
      <div>
        {this.props.formBuilder.getField('videos', {
          submitKey: 'videos_attributes',
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
        <Col xs={12} sm={2}>
          <Image
            style={{height: 100, "objectFit": 'cover'}}
            src={this.state.images[index]}
            responsive
          />
        </Col>
        <Col xs={12} sm={4}>
          {this.props.formBuilder.getNestedField('videos', 'name', index)}
        </Col>
        <Col xs={12} sm={2}>
          {this.props.formBuilder.getNestedField('videos', 'code', index)}
        </Col>
        <Col xs={12} sm={2}>
          {this.props.formBuilder.getNestedField('videos', 'video_type', index, {
            getInitialValue: (obj) => {
              return {value: obj.video_type, label: obj.video_type};
            }
          })}
        </Col>
        <Col xs={12} sm={2}>
          {this.props.formBuilder.getNestedField('videos', 'outstanding', index)}
        </Col>
      </Row>
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