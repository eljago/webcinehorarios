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
    controlId: PropTypes.string,
    cast: PropTypes.object,
    getPeopleOptions: PropTypes.func,
    onChange: PropTypes.func,
  };
  static defaultProps = {
    cast: Immutable.List()
  };

  constructor(props) {
    super(props);
    this.state = {
      currentCast: props.cast
    };
    _.bindAll(this,[
      '_handleChangeSelect',
      '_handleChangeCharacter',
    ]);
  }

  render() {
    return(
      <div>
        {this._getCastFields()}
      </div>
    );
  }

  _handleChangeSelect(index, value) {
    let indexPerson = this.state.currentCast.get(index);
    indexPerson = indexPerson.set('person_id', value.value);
    indexPerson = indexPerson.set('name', value.label);
    const currentCast = this.state.currentCast.set(index, indexPerson);
    this.setState({currentCast});
    const show_person_roles_attributes = currentCast.toJS();
    this.props.onChange(this.props.controlId, show_person_roles_attributes);
  }

  _handleChangeCharacter(index, character) {
    let indexPerson = this.state.currentCast.get(index);
    indexPerson = indexPerson.set('character', character);
    const currentCast = this.state.currentCast.set(index, indexPerson);
    this.setState({currentCast});
    const show_person_roles_attributes = currentCast.toJS();
    this.props.onChange(this.props.controlId, show_person_roles_attributes);
  }

  _getCastFields() {
    return this.state.currentCast.toJS().map((person, index) => {
      return(
        <Row>
          <Col xs={4}>
            <FormFieldSelect
              controlId={index}
              label={'Persona'}
              onChange={this._handleChangeSelect}
              initialValue={{value: person.id, label: person.name}}
              getOptions={this.props.getPeopleOptions}
            />
          </Col>
          <Col xs={8}>
            <FormFieldText
              controlId={index}
              label={'Character'}
              initialValue={person.character}
              onChange={this._handleChangeCharacter}
            />
          </Col>
        </Row>
      );
    });
  }
}