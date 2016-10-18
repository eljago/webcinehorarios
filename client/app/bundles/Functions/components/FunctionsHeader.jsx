'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

export default class FunctionsHeader extends React.Component {
  static propTypes = {
    title: PropTypes.string,
    subtitle: PropTypes.string,
  };

  render() {
    return (
      <div style={{display: 'flex', flexDirection: 'row', marginBottom: 10}}>
        <span style={{flex: 1, fontSize: 26}}>
          {this.props.title}
        </span>
        <span style={{flex: 1, color: 'gray', fontSize: 22}}>
          {this.props.subtitle}
        </span>
      </div>
    );
  }
}