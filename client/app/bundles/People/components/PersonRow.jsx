'use strict';

import React, { PropTypes } from 'react'
import update from 'react/lib/update';
import _ from 'lodash'

import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Button from 'react-bootstrap/lib/Button';
import Media from 'react-bootstrap/lib/Media';

import FormFieldText from '../../../lib/forms/FormFields/FormFieldText';

export default class PersonRow extends React.Component {
  static propTypes = {
    person: PropTypes.object,
    onSubmitPerson: PropTypes.func,
    onDeletePerson: PropTypes.func,
  };

  constructor(props) {
    super(props);
    this.state = {
      editing: false,
      submitting: false,
    };
  }

  render() {
    const person = this.props.person;
    return (
      <Row>
        <Col xs={12} md={8} lg={8}>
          <Media>
           <Media.Left>
              <img
                style={{width: 80, height: 120, contentFit: 'contain'}}
                src={`http://cinehorarios.cl${_.get(person, 'image.smallest.url')}`}
                alt="Image"
              />
            </Media.Left>
            <Media.Body>
              {this._getContentField()}
            </Media.Body>
          </Media>
        </Col>
        <Col xs={12} md={2} lg={2}>
          <Button
            style={{marginTop: 10, marginBottom: 10}}
            disabled={this.state.submitting}
            bsStyle={this.state.editing ? "success" : "default"}
            onClick={() => {
              this._onEdit()
            }}
            block
          >
            {this._getEditButtonTitle()}
          </Button>
        </Col>
        <Col xs={12} md={2} lg={2}>
          <Button
            style={{marginTop: 10, marginBottom: 10}}
            bsStyle={this.state.editing ? "warning" : "danger"}
            disabled={this.state.submitting}
            onClick={() => {
              this._onDelete()
            }}
            block
          >
            {this._getDeleteButtonTitle()}
          </Button>
        </Col>
      </Row>
    );
  }

  _getContentField() {
    if (this.state.editing) {
      return(
        <div>
          <FormFieldText
            submitKey='name'
            label='Nombre'
            ref='name'
            initialValue={this.props.person.name}
          />
          <FormFieldText
            submitKey='imdb_code'
            label='Imdb Code'
            ref='imdbCode'
            initialValue={this.props.person.imdb_code}
          />
        </div>
      );
    }
    return ([
      <Media.Heading>{this.props.person.name}</Media.Heading>,
      <p>{this.props.person.id}</p>,
      <p>{this.props.person.imdb_code}</p>
    ]);
  }

  _getEditButtonTitle() {
    if (this.state.submitting) {
      return 'Submitting';
    }
    else if (this.state.editing) {
      return 'Submit';
    }
    return 'Editar';
  }

  _getDeleteButtonTitle() {
    if (this.state.submitting) {
      return 'Submitting';
    }
    else if (this.state.editing) {
      return 'Cancelar';
    }
    return 'Eliminar';
  }

  _onEdit() {
    if (this.state.submitting) {
      
    }
    else if (this.state.editing) { // SUBMIT PERSON
      const submitName = this.refs.name.getResult();
      const submitImdbCode = this.refs.imdbCode.getResult();
      if (submitName && submitImdbCode) {
        const person = {
          id: this.props.person.id,
          ...submitName,
          ...submitImdbCode
        }
        this.props.onSubmitPerson(person, (result, errors) => {
          this.setState({
            editing: false
          });
        });
      }
      else {
        this.setState({
          editing: false
        });
      }
    }
    else { // START EDIT
      this.setState({
        editing: true
      });
    }
  }

  _onDelete() {
    if (this.state.submitting) {

    }
    else if (this.state.editing) { // CANCEL EDIT
      this.setState({
        editing: false,
        person: this.props.person,
      })
    }
    else if (confirm(`¿Eliminar Persona: ${this.props.person.name}?`)) { // DELETE PERSON
      this.setState({
        submitting: true
      });
      this.props.onDeletePerson(this.props.person.id, (result, errors = null) => {
        this.setState({
          submitting: false
        });
      });
    }
  }
}
