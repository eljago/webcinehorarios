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

import FormFieldText from '../../../lib/forms/FormFields/FormFieldText'
import FormFieldFile from '../../../lib/forms/FormFields/FormFieldFile'
import FormFieldSelect from '../../../lib/forms/FormFields/FormFieldSelect'
import FormFieldDate from '../../../lib/forms/FormFields/FormFieldDate'
import FormFieldRadioGroup from '../../../lib/forms/FormFields/FormFieldRadioGroup'
import FormFieldCheckboxGroup from '../../../lib/forms/FormFields/FormFieldCheckboxGroup'

export default class ShowFormCast extends React.Component {
  static propTypes = {
    controlId: PropTypes.string,
    cast: PropTypes.object,
    getPeopleOptions: PropTypes.func,
  };
  static defaultProps = {
    cast: []
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
    let indexPerson = this.state.currentCast[index];
    indexPerson.person_id = value.value;
    indexPerson.name = value.label;

    let currentCast = this.state.currentCast;
    currentCast[index] = indexPerson;
    this.setState({currentCast});
  }

  _handleChangeCharacter(index, character) {
    let indexPerson = this.state.currentCast[index];
    indexPerson.character = character;

    let currentCast = this.state.currentCast;
    currentCast[index] = indexPerson;
    this.setState({currentCast});
  }

  _handleDelete(index) {
    let currentCast = this.state.currentCast;
    let indexPerson = this.state.currentCast[index];
    if (indexPerson.id) {
      indexPerson._destory = true;
      currentCast[index] = indexPerson;
    }
    else {
      _.pullAt(currentCast, [index]);
    }
    this.setState({currentCast});
  }

  _handleNewPerson() {
    let currentCast = this.state.currentCast;
    currentCast.push({});
    this.setState({currentCast});
  }

  _getCastFields() {
    return this.state.currentCast.map((person, index) => {
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