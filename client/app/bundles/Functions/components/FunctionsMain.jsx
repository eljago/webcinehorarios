'use strict';

import React, { PropTypes } from 'react'

import ShowRow from './ShowRow'

export default class FunctionsMain extends React.Component {
  static propTypes = {
    shows: PropTypes.array,
    loadingContent: PropTypes.boolean,
    functionTypes: PropTypes.array,
  };
  static defaultProps = {
    shows: [],
    loadingContent: false,
  }

  render() {
    return (
      <div>
        {this._getFunctions()}
      </div>
    );
  }

  _getFunctions() {
    console.log(this.props.functionTypes);
    if (this.props.loadingContent) {
      return(<h1>Loading...</h1>);
    }
    else {
      return this.props.shows.map((show) => {
        return(
          <ShowRow show={show} functionTypes={this.props.functionTypes} />
        );
      });
    }
  }
}
