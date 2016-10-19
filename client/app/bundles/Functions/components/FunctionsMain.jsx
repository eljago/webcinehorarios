'use strict';

import React, { PropTypes } from 'react'

import FormRow from './FormRow'

export default class FunctionsMain extends React.Component {
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
          <FormRow formBuilder={formBuilder} />
        );
      });
    }
  }
}
