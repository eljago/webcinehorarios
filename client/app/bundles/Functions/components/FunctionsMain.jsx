'use strict';

import React, { PropTypes } from 'react'

import ShowRow from './ShowRow'

export default class FunctionsMain extends React.Component {
  static propTypes = {
    shows: PropTypes.array,
    functionTypes: PropTypes.array,
  };
  static defaultProps = {
    shows: [],
  }

  render() {
    return (
      <div>
        <table className="table table-striped">
          <tbody>
            {this._getFunctions()}
          </tbody>
        </table>
      </div>
    );
  }

  _getFunctions() {
    return this.props.shows.map((show, index) => {
      return(
        <ShowRow
          key={show.id}
          style={{backgroundColor: index % 2 == 0 ? 'white' : '#F1F1F1'}}
          show={show}
          functionTypes={this.props.functionTypes}
        />
      );
    });
  }
}