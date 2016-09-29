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
  };

  render() {
    const person = this.props.person;
    return (
      <Row>
        <Col xs={12} md={10} lg={10}>
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
        <Col xs={12} md={2} lg={2}>
          <Button
            style={{marginTop: 10, marginBottom: 10}}
            bsStyle={"default"}
            onClick={() => {
              this.props.onEditPerson(this.props.person);
            }}
            block
          >
            Editar
          </Button>
        </Col>
      </Row>
    );
  }
}
