'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import Immutable from 'immutable'

import Button from 'react-bootstrap/lib/Button';
import Form from 'react-bootstrap/lib/Form';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Checkbox from 'react-bootstrap/lib/Checkbox';
import FormGroup from 'react-bootstrap/lib/FormGroup';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';

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
      '_handleDelete',
      '_handleNewPerson',
    ]);
  }

  render() {
    return(
      <div>

        <br/>

        {this._getCastFields()}

        <br/>

        <Button
          bsStyle="primary"
          onClick={this._handleNewPerson}
        >
          Nuevo
        </Button>
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

  _handleDelete(index) {
    let currentCast = this.state.currentCast;
    let indexPerson = currentCast.get(index);
    if (indexPerson.get('id')) {
      indexPerson = indexPerson.set('_destroy', true);
      currentCast = currentCast.set(index, indexPerson);
    }
    else {
      currentCast = currentCast.delete(index)
    }
    this.setState({currentCast});
    const show_person_roles_attributes = currentCast.toJS();
    this.props.onChange(this.props.controlId, show_person_roles_attributes);
  }

  _handleNewPerson() {
    const newPerson = Immutable.Map();
    const currentCast = this.state.currentCast.push(newPerson);
    this.setState({currentCast});
    const show_person_roles_attributes = currentCast.toJS();
    this.props.onChange(this.props.controlId, show_person_roles_attributes);
  }

  _getCastFields() {
    return this.state.currentCast.toJS().map((person, index) => {
      if (person._destroy) {
        return null;
      }
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
          <Col xs={4}>
            <FormFieldText
              controlId={index}
              label={'Character'}
              initialValue={person.character}
              onChange={this._handleChangeCharacter}
            />
          </Col>
          <Col xs={1}>
            <FormGroup>
              <ControlLabel>Actor</ControlLabel>
              <Checkbox />
            </FormGroup>
          </Col>
          <Col xs={1}>
            <FormGroup>
              <ControlLabel>Director</ControlLabel>
              <Checkbox />
            </FormGroup>
          </Col>
          <Col xs={2}>
            <Button
              bsStyle="danger"
              onClick={() => {this._handleDelete(index)}}
              style={{marginTop: 25}}
            >
              Eliminar
            </Button>
          </Col>
        </Row>
      );
    });
  }
}