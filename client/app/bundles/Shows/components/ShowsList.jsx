'use strict';

import React, { PropTypes } from 'react';

import ShowRow from './ShowRow'

export default class ShowsList extends React.Component {
  static propTypes = {
    shows: PropTypes.object.isRequired,
    loadingContent: PropTypes.boolean,
  };

  render() {
    return (
      <div>
        {this._getRows()}
      </div>
    )
  }

  _getRows() {
    if (this.props.loadingContent) {
      return <h1>Loading ...</h1>;
    }
    else {
      return this.props.shows.map((show, i) => {
        return(
          <ShowRow key={show.id} show={show} index={i}/>
        );
      });
    }
  }
}