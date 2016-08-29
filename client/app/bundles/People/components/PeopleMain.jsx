'use strict';

import React, { PropTypes } from 'react';

import PersonRow from './PersonRow';
import PersonForm from './PersonForm';
import SearchField from '../../../lib/forms/FormFields/SearchField'

import PageHeader from 'react-bootstrap/lib/PageHeader';
import Button from 'react-bootstrap/lib/Button';
import Image from 'react-bootstrap/lib/Image';
import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Pagination from 'react-bootstrap/lib/Pagination';
import FormGroup from 'react-bootstrap/lib/FormGroup';
import FormControl from 'react-bootstrap/lib/FormControl';
import InputGroup from 'react-bootstrap/lib/InputGroup';
import Modal from 'react-bootstrap/lib/Modal';

export default class PeopleMain extends React.Component {
  static propTypes = {
    page: PropTypes.number.isRequired,
    itemsPerPage: PropTypes.number.isRequired,
    people: PropTypes.object.isRequired,
    pagesCount: PropTypes.number.isRequired,
    onChangePage: PropTypes.func,
    onSearchPerson: PropTypes.func,
    onSubmitPerson: PropTypes.func,
    onDeletePerson: PropTypes.func,
    onSearchPeople: PropTypes.func,
  };

  constructor(props){
    super(props);
    this.state = {
      editingPerson: false,
      currentPerson: null,
    }
    _.bindAll(this, ['_onStartEditing', '_closeModal'])
  }

  render() {
    const items = Math.ceil(this.props.pagesCount / this.props.itemsPerPage)
    return (
      <div>
        <Row>
          <Col xs={12} md={2}>
            <Button
              style={{marginBottom: 10}}
              bsStyle="primary"
              onClick={() => {
                this.setState({
                  currentPerson: {},
                  editingPerson: true
                })
              }}
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
                this.props.onSearchPeople(searchValue);
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
        <Modal show={this.state.editingPerson} onHide={this._closeModal}>
          <Modal.Header closeButton>
            <Modal.Title>Person</Modal.Title>
          </Modal.Header>
          <Modal.Body>
            <PersonForm
              person={this.state.currentPerson}
              onSubmit={this.props.onSubmitPerson}
              onClose={() => {
                this.setState({editingPerson: false});
              }}
            />
          </Modal.Body>
        </Modal>
      </div>
    )
  }

  _closeModal() {
    this.setState({
      currentPerson: null,
      editingPerson: false,
    });
  }

  _onStartEditing(person) {
    this.setState({
      currentPerson: person,
      editingPerson: true,
    });
  }

  _getRows() {
    return this.props.people.map((person, i) => {
      return(
        <PersonRow
          key={person.id}
          person={person}
          onEditPerson={this._onStartEditing}
          onDeletePerson={this.props.onDeletePerson}
        />
      );
    });
  }
}
