'use strict';

import React, { PropTypes } from 'react'

import EditShowRow from './EditShowRow'

export default class EditFunctionsMain extends React.Component {
  static propTypes = {
    formBuilders: PropTypes.array,
    loadingContent: PropTypes.boolean,
  };

  render() {
    return (
      <div>
        {this._getFunctions()}
      </div>
    );
  }

  _getFunctions() {
    if (this.props.loadingContent) {
      return(<h1>Loading...</h1>);
    }
    else {
      return this.props.formBuilders.map((formBuilder) => {
        return(
          <EditShowRow key={formBuilder.object.id} formBuilder={formBuilder} />
        );
      });
    }
  }

  getResult() {

  }
}
