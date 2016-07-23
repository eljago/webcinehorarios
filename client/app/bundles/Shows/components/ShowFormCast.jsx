'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import Immutable from 'immutable'

import Button from 'react-bootstrap/lib/Button';
import Form from 'react-bootstrap/lib/Form';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

import FormFieldText from '../../../lib/forms/FormFieldText'
import FormFieldFile from '../../../lib/forms/FormFieldFile'
import FormFieldSelect from '../../../lib/forms/FormFieldSelect'
import FormFieldDate from '../../../lib/forms/FormFieldDate'
import FormFieldRadioGroup from '../../../lib/forms/FormFieldRadioGroup'
import FormFieldCheckboxGroup from '../../../lib/forms/FormFieldCheckboxGroup'

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