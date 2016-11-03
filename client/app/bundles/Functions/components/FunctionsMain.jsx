'use strict';

import React, { PropTypes } from 'react'

import FunctionsRow from './FunctionsRow'

export default class FunctionsMain extends React.Component {
  static propTypes = {
    functionsContainers: PropTypes.array,
    functionTypes: PropTypes.array,
  };
  static defaultProps = {
    functionsContainers: [],
  }

  render() {
    return (
      <div>
        <table className="table table-striped">
          <tbody>
            {this._getFunctionsRows()}
          </tbody>
        </table>
      </div>
    );
  }

  _getFunctionsRows() {
    return this.props.functionsContainers.map((functionsContainer, index) => {
      return(
        <FunctionsRow
          key={functionsContainer.id}
          style={{backgroundColor: index % 2 == 0 ? 'white' : '#F1F1F1'}}
          functionsContainer={functionsContainer}
          functionTypes={this.props.functionTypes}
        />
      );
    });
  }
}