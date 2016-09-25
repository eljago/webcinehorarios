'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import PeopleMain from '../components/PeopleMain'

import {PeopleQueries, SelectQueries} from '../../../lib/api/queries'

export default class People extends React.Component {

  static propTypes = {
    defaultPerson: PropTypes.object,
  };

  constructor(props) {
    super(props);
    this.state = {
      page: 1,
      itemsPerPage: 15,
      people: [],
      pagesCount: null,
      currentSearch: '',
    };
    _.bindAll(this, [
      '_updateData',
      '_onChangePage',
      '_onSearch',
      '_onSubmit',
      '_onDelete',
    ]);
  }

  componentDidMount() {
    this._updateData();
  }

  render() {
    return (
      <PeopleMain
        defaultPerson={this.props.defaultPerson}
        page={this.state.page}
        itemsPerPage={this.state.itemsPerPage}
        people={this.state.people}
        pagesCount={this.state.pagesCount}
        onChangePage={this._onChangePage}
        onSearchPerson={this._onSearch}
        onSubmitPerson={this._onSubmit}
        onDeletePerson={this._onDelete}
        onSearchPeople={this._onSearch}
      />
    );
  }

  _updateData(newPage = this.state.page, searchValue = this.state.currentSearch) {
    PeopleQueries.getPeople({
      page: newPage,
      perPage: this.state.itemsPerPage,
      searchValue: searchValue,
      success: (response) => {
        this.setState({
          page: newPage,
          people: response.people.map((person) => {
            return {
              id: person.id,
              name: person.name,
              imdb_code: person.imdb_code,
              image: person.image
            }
          }),
          pagesCount: response.count,
          currentSearch: searchValue
        });
      }
    });
  }

  _onChangePage(newPage) {
    this._updateData(newPage);
  }

  _onSearch(searchValue) {
    this._updateData(1, searchValue);
  }


  _onSubmit(personData, callback = null) {
    const success = (response) => {
      this._updateData();
      callback(true);
    };
    const error = (error) => {
      if (error.status == 422) {
        callback(false, error.responseJSON.errors);
      }
      else if (error.status == 500) {
        callback(false, {Error: ['ERROR 500']});
      }
      else {
        callback(false);
      }
    };
    if (personData.id) {
      PeopleQueries.submitEditPerson({
        person: personData,
        success: success,
        error: error
      });
    }
    else {
      PeopleQueries.submitNewPerson({
        person: personData,
        success: success,
        error: error
      });
    }
  }

  _onDelete(personId, callback = null) {
    PeopleQueries.submitDeletePerson({
      personId: personId,
      success: (response) => {
        this._updateData();
        callback(true);
      }
    });
  }
}
