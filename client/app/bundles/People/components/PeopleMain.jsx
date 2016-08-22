'use strict';

import React, { PropTypes } from 'react';

import PersonRow from './PersonRow';
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

  render() {
    const items = Math.ceil(this.props.pagesCount / this.props.itemsPerPage)
    return (
      <div className="container">
        <PageHeader>Shows <small>Main</small></PageHeader>
        <Row>
          <Col xs={12} md={2}>
            <Button
              style={{marginBottom: 10}}
              bsStyle="primary"
              href='/admin/people/new'
              block
            >
              Nuevo
            </Button>
          </Col>
          <Col xs={12} md={8}>
            <SearchField
              placeholder='Buscar Persona'
              onSearch={this.props.onSearchPeople}
            />
          </Col>
        </Row>
        <Pagination prev next first last ellipsis maxButtons={6}
          items={items}
          activePage={this.props.page}
          onSelect={this.props.onChangePage}
        />
        <Grid>
          {this._getRows()}
        </Grid>
      </div>
    )
  }

  _getRows() {
    return this.props.people.map((person, i) => {
      return(
        <PersonRow
          key={person.id}
          person={person}
          onSubmitPerson={this.props.onSubmitPerson}
          onDeletePerson={this.props.onDeletePerson}
        />
      );
    });
  }
}
