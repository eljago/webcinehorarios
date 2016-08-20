'use strict';

import React, { PropTypes } from 'react'
import ReactDOM from 'react-dom'
import Immutable from 'immutable'
import _ from 'lodash'
import ShowsMain from '../components/ShowsMain'
import ShowForm from '../components/ShowForm'

const SHOWS_PER_PAGE = 15;

export default class Shows extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      page: 1,
      showsPerPage: 15,
      shows: Immutable.List(),
      pagesCount: null,

    };
    _.bindAll(this, [
      '_updateShowsTable',
      '_handleDelete',
      '_onChangePage',
      '_onSearchShow',
      '_onDeleteShow',
    ]);
  }

  componentDidMount() {
    this._updateShowsTable();
  }

  render() {
    return (
      <ShowsMain
        page={this.state.page}
        itemsPerPage={SHOWS_PER_PAGE}
        shows={this.state.shows}
        pagesCount={this.state.pagesCount}
        handleDelete={this._handleDelete}
        onChangePage={this._onChangePage}
        onSearchShow={this._onSearchShow}
        onDeleteShow={this._onDeleteShow}
      />
    );
  }

  _updateShowsTable(newPage = this.state.page, searchValue = '') {
    const queryString = 
      `/api/shows.json?page=${newPage}&perPage=${SHOWS_PER_PAGE}&query=${searchValue}`;
    $.getJSON(queryString, (response) => {
      this.setState({
        page: newPage,
        shows: Immutable.fromJS(response.shows),
        pagesCount: response.count
      });
    });
  }

  _handleDelete(id) {
    $.ajax({
      url: `/api/shows/${id}`,
      type: 'DELETE',
      success: (response) => {
        this._updateShowsTable();
      }
    });
  }

  _onChangePage(newPage) {
    this._updateShowsTable(newPage);
  }

  _onSearchShow(searchValue) {
    this._updateShowsTable(1, searchValue);
  }

  _onDeleteShow(showID) {
    console.log(showID)
    $.ajax({
      url: `/api/shows/${showID}`,
      type: 'DELETE',
      success: (response) => {
        this._updateShowsTable();
      },
      error: (error) => {
        let errors = {};
        if (error.status == 422) { // Rails validations failed
          errors = !_.isEmpty(error.responseJSON.errors) ? error.responseJSON.errors : {},
          window.scrollTo(0, 0);
        }
        else if (error.status == 500) {
          errors = {Error: ['ERROR 500']}
          window.scrollTo(0, 0);
        }
        this.setState({errors});
      }
    });
  }
}
