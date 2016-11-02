'use strict';

import React, { PropTypes } from 'react';

export default class FormFieldHidden extends React.Component {
  static propTypes = {
    identifier: PropTypes.string,
    submitKey: PropTypes.string,
    initialValue: PropTypes.string,
  };

  render() {
    const {
      submitKey,
      initialValue,
      identifier,
    } = this.props;

    return(
      <input
        type="hidden"
        name={submitKey}
        id={identifier}
        value={initialValue}
      />
    );
  }

  getResult() {
    return {[this.props.submitKey]: this.props.initialValue};
  }
}
