'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormBuilderShow from '../../../lib/forms/FormBuilders/FormBuilderShow'

export default class ShowFormCast extends React.Component {
  static propTypes = {
    formBuilder: PropTypes.instanceOf(FormBuilderShow)
  };

  constructor(props) {
    super(props);
  }

  render() {
    return(
      <div>
        {this.props.formBuilder.getFormField('show_person_roles')}
      </div>
    );
  }
}