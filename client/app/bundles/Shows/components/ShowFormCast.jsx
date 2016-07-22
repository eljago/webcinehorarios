'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import Immutable from 'immutable'
import {
  Button,
  Form,
  Row,
  Col
} from 'react-bootstrap'

import {
  FormFieldText,
  FormFieldFile,
  FormFieldSelect,
  FormFieldDate,
  FormFieldRadioGroup,
  FormFieldCheckboxGroup,
} from '../../../lib/forms'

export default class ShowFormCast extends React.Component {
  static propTypes = {
    cast: PropTypes.object
  };
  static defaultProps = {
    cast: Immutable.List()
  };

  constructor(props) {
    super(props);
    this.state = {
      currentCast: props.cast
    };
    _.bindAll(this, [
      '_handleChange',
    ]);
  }

  render() {
    return(
      <div>
        {this._getCastFields()}
      </div>
    );
  }

  _handleChange(controlId, value) {

  }

  _getCastFields() {
    return this.state.currentCast.toJS().map((person, index) => {
      return(
        <Row>
          <Col xs={12}>
            <FormFieldText
              controlId={person.person_id}
              label={'Nombre'}
              initialValue={person.character}
              onChange={this._handleChange}
            />
          </Col>
        </Row>
      );
    });
  }
}