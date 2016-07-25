'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import Immutable from 'immutable'

export default class ShowFormCast extends React.Component {
  static propTypes = {
    controlId: PropTypes.string.isRequired,
    person: PropTypes.object.isRequired,
    getPeopleOptions: PropTypes.func.isRequired,
    formBuilder: PropTypes.object.isRequired,
  };

  constructor(props) {
    super(props);
  }

  render() {
    const {controlId, person, getPeopleOptions} = this.props;
    if (person._destroy) {
      return null;
    }
    return(
      <Row>
        <Col xs={4}>
          {formBuilder.getFormField()}
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
  }
}