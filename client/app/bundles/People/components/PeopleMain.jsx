'use strict';

import React, { PropTypes } from 'react';

import PersonRow from './PersonRow';
import PersonForm from './PersonForm';
import SearchField from '../../../lib/forms/FormFields/SearchField'

import Button from 'react-bootstrap/lib/Button';
import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Pagination from 'react-bootstrap/lib/Pagination';
import Modal from 'react-bootstrap/lib/Modal';

import FormBuilder from '../../../lib/forms/FormBuilder';

export default class PeopleMain extends React.Component {
  static propTypes = {
    formBuilder: PropTypes.instanceOf(FormBuilder),
    errors: PropTypes.object,
    submitting: PropTypes.bool,
    editing: PropTypes.bool,
    page: PropTypes.number.isRequired,
    itemsPerPage: PropTypes.number.isRequired,
    people: PropTypes.object.isRequired,
    pagesCount: PropTypes.number.isRequired,
    onChangePage: PropTypes.func,
    onSearchPerson: PropTypes.func,
    onStartEditing: PropTypes.func,
    onEndEditing: PropTypes.func,
  };

  render() {
    const items = Math.ceil(this.props.pagesCount / this.props.itemsPerPage);
    return (
      <div>
        <Row>
          <Col xs={12} md={2}>
            <Button
              style={{marginBottom: 10}}
              bsStyle="primary"
              onClick={this.props.onStartEditing}
              block
            >
              Nuevo
            </Button>
          </Col>
          <Col xs={12} md={8}>
            <SearchField
              ref='searchField'
              placeholder='Buscar Persona'
              onSearch={(searchValue) => {
                this.props.onSearchPerson(searchValue);
              }}
            />
          </Col>
        </Row>
        <Pagination prev next first last ellipsis maxButtons={5}
          items={items}
          activePage={this.props.page}
          onSelect={this.props.onChangePage}
        />
        <Grid>
          {this._getRows()}
        </Grid>
        <Pagination prev next first last ellipsis maxButtons={5}
          items={items}
          activePage={this.props.page}
          onSelect={this.props.onChangePage}
        />
        <Modal show={this.props.editing} onHide={this.props.onEndEditing}>
          <Modal.Header closeButton>
            <Modal.Title>Person</Modal.Title>
          </Modal.Header>
          <Modal.Body>
            <PersonForm
              ref='form'
              formBuilder={this.props.formBuilder}
              submitting={this.props.submitting}
              errors={this.props.errors}
              onClose={this.props.onEndEditing}
            />
          </Modal.Body>
        </Modal>
      </div>
    )
  }

  _getRows() {
    return this.props.people.map((person, i) => {
      return(
        <PersonRow
          key={person.id}
          person={person}
          onEditPerson={this.props.onStartEditing}
          onDeletePerson={this.props.onDeletePerson}
        />
      );
    });
  }
}
