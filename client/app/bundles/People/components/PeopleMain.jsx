'use strict';

import React, { PropTypes } from 'react';

import PersonRow from './PersonRow';
import PersonForm from './PersonForm';
import SearchField from '../../../lib/forms/FormFields/SearchField'

import Pagination from 'react-bootstrap/lib/Pagination';

import FormBuilder from '../../../lib/forms/FormBuilder';

export default class PeopleMain extends React.Component {
  static propTypes = {
    page: PropTypes.number.isRequired,
    itemsPerPage: PropTypes.number.isRequired,
    people: PropTypes.object.isRequired,
    pagesCount: PropTypes.number.isRequired,
    onChangePage: PropTypes.func,
    onSearchPerson: PropTypes.func,
    onEditPerson: PropTypes.func,
  };

  render() {
    const items = Math.ceil(this.props.pagesCount / this.props.itemsPerPage);
    return (
      <div>
        <SearchField
          ref='searchField'
          placeholder='Buscar Persona'
          onSearch={(searchValue) => {
            this.props.onSearchPerson(searchValue);
          }}
        />
        <Pagination prev next first last ellipsis maxButtons={5}
          items={items}
          activePage={this.props.page}
          onSelect={this.props.onChangePage}
        />
        <div style={styles.container}>
          {this._getRows()}
        </div>
        <Pagination prev next first last ellipsis maxButtons={5}
          items={items}
          activePage={this.props.page}
          onSelect={this.props.onChangePage}
        />
      </div>
    )
  }

  _getRows() {
    return this.props.people.map((person) => {
      return(
        <PersonRow
          key={person.id}
          person={person}
          onEditPerson={() => {this.props.onEditPerson(person)}}
        />
      );
    });
  }
}

const styles = {
  container: {
    display: 'flex',
    flexDirection: 'row',
    flexWrap: 'wrap'
  },
}
