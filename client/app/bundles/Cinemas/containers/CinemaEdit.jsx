'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';

import CinemaForm from '../components/CinemaForm'

import {CinemasQueries} from '../../../lib/api/queries'

import FormBuilder from '../../../lib/forms/FormBuilder';
import GetFormSchema from '../data/FormSchema'

export default class CinemaEdit extends React.Component {

  static propTypes = {
    cinema: PropTypes.object,
  };

  constructor(props) {
    super(props);
    this.state = {
      submitting: false,
      errors: {},
    };
  }

  render() {
    return (
      <CinemaForm
        cinema={this.props.cinema}
        
      />
    );
  }
}
