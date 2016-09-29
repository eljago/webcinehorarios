'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import update from 'react/lib/update';

import PeopleMain from '../components/PeopleMain'

import {PeopleQueries, SelectQueries} from '../../../lib/api/queries'

import FormBuilder from '../../../lib/forms/FormBuilder';
import GetFormSchema from '../data/FormSchema'

export default class People extends React.Component {

  static propTypes = {
    defaultPerson: PropTypes.object,
  };

  constructor(props) {
    super(props);
    this.state = {
      errors: {},
      submitting: false,
      editing: false,
      page: 1,
      itemsPerPage: 15,
      people: [],
      pagesCount: null,
      currentSearch: '',
      formBuilder: null
    };
    _.bindAll(this, [
      '_updateData',
      '_onChangePage',
      '_onSearch',
      '_handleSubmit',
      '_onDelete',
      '_onStartEditing',
      '_onEndEditing',
    ]);
  }

  componentDidMount() {
    this._updateData();
  }

  render() {
    return (
      <PeopleMain
        ref='form'
        errors={this.state.errors}
        formBuilder={this.state.formBuilder}
        submitting={this.state.submitting}
        editing={this.state.editing}
        onStartEditing={this._onStartEditing}
        onEndEditing={this._onEndEditing}
        page={this.state.page}
        itemsPerPage={this.state.itemsPerPage}
        people={this.state.people}
        pagesCount={this.state.pagesCount}
        onChangePage={this._onChangePage}
        onSearchPerson={this._onSearch}
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
          currentSearch: searchValue,
        });
      }
    });
  }

  _onStartEditing(person) {
    this.setState({
      editing: true,
      formBuilder: new FormBuilder(
        GetFormSchema({
          onDelete: this._onDelete,
          onSubmit: this._handleSubmit
        }),
        (person ? person : this.props.defaultPerson)
      )
    });
  }

  _onEndEditing() {
    this.setState({
      editing: false,
    });
  }

  _onChangePage(newPage) {
    this._updateData(newPage);
  }

  _onSearch(searchValue) {
    this._updateData(1, searchValue);
  }


  _handleSubmit() {
    let submitOptions = this.refs.form.refs.form.getResult();
    const success = (response) => {
      this._updateData();
      this.setState({
        submitting: false,
        editing: false
      });
    };
    const error = (errors) => {
      this.setState({
        errors: errors,
        submitting: false,
      });
    };
    this.setState({submitting: true});
    if (this.state.formBuilder.object.id) {
      PeopleQueries.submitEditPerson({
        person: update(submitOptions, {id: {$set: this.state.formBuilder.object.id}}),
        success: success,
        error: error
      });
    }
    else {
      PeopleQueries.submitNewPerson({
        person: submitOptions,
        success: success,
        error: error
      });
    }
  }

  _onDelete() {
    this.setState({submitting: true});
    PeopleQueries.submitDeletePerson({
      personId: this.state.formBuilder.object.id,
      success: (response) => {
        this._updateData();
        this.setState({
          submitting: false,
          editing: false
        });
      },
      error: (errors) => {
        this.setState({
          errors: errors,
          submitting: false,
        });
      }
    });
  }
}
