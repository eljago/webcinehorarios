'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormBuilderShow from '../../../lib/forms/FormBuilders/FormBuilderShow'

export default class ShowFormImages extends React.Component {
  static propTypes = {
    formBuilder: PropTypes.instanceOf(FormBuilderShow)
  };

  constructor(props) {
    super(props);
  }

  render() {
    return(
      <div>
        {this.props.formBuilder.getFormField('images')}
      </div>
    );
  }

  getResult() {
    let showResult = {};
    _.forIn(this.refs, (formElement, key) => {
      if (_.isFunction(formElement.getResult)) {
        _.merge(showResult, formElement.getResult());
      }
    });
    return showResult;
  }
}