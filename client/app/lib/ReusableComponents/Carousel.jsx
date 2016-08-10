'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Carousel from 'react-bootstrap/lib/Carousel';
import Image from 'react-bootstrap/lib/Image';

export default class Car extends React.Component {
  static propTypes = {
    images: PropTypes.array.isRequired,
    initialIndex: PropTypes.number,
  };
  static defaultProps = {
    initialIndex: 0
  }

  size = {
    width: 900,
    height: 500
  };

  constructor(props) {
    super(props);
    this.state = {
      index: props.initialIndex,
      direction: null
    };
    _.bindAll(this, '_handleSelect');
  }

  render() {
    return (
      <Carousel activeIndex={this.state.index} direction={this.state.direction} onSelect={this._handleSelect}>
        {this._getItems()}
      </Carousel>
    );
  }

  _getItems() {
    return this.props.images.map((image) => {
      return(
        <Carousel.Item>
          <Image style={{
            backgroundColor: 'black',
            width: this.size.width,
            height: this.size.height,
            "objectFit": 'contain'
          }}
          src={image} />
        </Carousel.Item>
      );
    })
  }

  _handleSelect(selectedIndex, e) {
    this.setState({
      index: selectedIndex,
      direction: this._getDirection(selectedIndex)
    });
  }

  _getDirection(selectedIndex) {
    if (this.state.index === selectedIndex) {
      return null;
    }

    return this.state.index > selectedIndex ? 'prev' : 'next';
  }
}