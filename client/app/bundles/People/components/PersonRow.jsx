'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Button from 'react-bootstrap/lib/Button';
import Media from 'react-bootstrap/lib/Media';

import FormFieldText from '../../../lib/forms/FormFields/FormFieldText';

export default class PersonRow extends React.Component {
  static propTypes = {
    person: PropTypes.object,
    onEditPerson: PropTypes.func,
    onDeletePerson: PropTypes.func,
  };

  constructor(props) {
    super(props);
    this.state = {
      submitting: false
    }
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
                src={_.get(person, 'image.smallest.url')}
                alt="Image"
              />
            </Media.Left>
            <Media.Body>
              <Media.Heading>{person.name}</Media.Heading>
              <p>{person.id}</p>
              <p>{person.imdb_code}</p>
            </Media.Body>
          </Media>
        </Col>
        <Col xs={6} md={2} lg={2}>
          <Button
            style={{marginTop: 10, marginBottom: 10}}
            disabled={this.state.submitting}
            bsStyle={"default"}
            onClick={() => {
              this.props.onEditPerson(this.props.person);
            }}
            block
          >
            Editar
          </Button>
        </Col>
        <Col xs={6} md={2} lg={2}>
          <Button
            style={{marginTop: 10, marginBottom: 10}}
            bsStyle={"danger"}
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

  _getDeleteButtonTitle() {
    if (this.state.submitting) {
      return 'Submitting';
    }
    return 'Eliminar';
  }

  _onDelete() {
    this.props.onDeletePerson(this.props.person.id, (result, errors = null) => {
      this.setState({
        submitting: false
      });
    });
  }
}
