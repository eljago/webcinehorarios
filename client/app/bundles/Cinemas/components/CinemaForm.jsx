'use strict';

import React, { PropTypes } from 'react';

import ErrorMessages from '../../../lib/forms/FormFields/ErrorMessages'
import FormFieldText from '../../../lib/forms/FormFields/FormFieldText'
import FormFieldRadioGroup from '../../../lib/forms/FormFields/FormFieldRadioGroup'

export default class CinemaForm extends React.Component {

  static propTypes = {
    cinema: PropTypes.object
  };

  render() {
    const cinema = this.props.cinema;
    return (
      <div>
        <ErrorMessages errors={this.props.errors} />

        <FormFieldText
          submitKey='name'
          label='Nombre'
          ref='name'
          initialValue={cinema ? cinema.name : ''}
        />
      </div>
    );
  }
}
