'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import ShowsMain from '../components/ShowsMain'
import ShowForm from '../components/ShowForm'

export default class Shows extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      page: 1,
      showsPerPage: 15,
      shows: [],
      pagesCount: null,

    };
    _.bindAll(this, [
      '_updateData',
      '_onChangePage',
      '_onSearch',
      '_onDelete',
    ]);
  }

  componentDidMount() {
    this._updateData();
  }

  render() {
    return (
      <ShowsMain
        page={this.state.page}
        itemsPerPage={this.state.showsPerPage}
        shows={this.state.shows}
        pagesCount={this.state.pagesCount}
        onChangePage={this._onChangePage}
        onSearchShow={this._onSearch}
        onDeleteShow={this._onDelete}
      />
    );
  }

  _updateData(newPage = this.state.page, searchValue = '') {
    const queryString = 
      `/api/shows.json?page=${newPage}&perPage=${this.state.showsPerPage}&query=${searchValue}`;
    $.getJSON(queryString, (response) => {
      this.setState({
        page: newPage,
        shows: response.shows,
        pagesCount: response.count
      });
    });
  }

  _onChangePage(newPage) {
    this._updateData(newPage);
  }

  _onSearch(searchValue) {
    this._updateData(1, searchValue);
  }

  _onDelete(showID) {
    $.ajax({
      url: `/api/shows/${showID}`,
      type: 'DELETE',
      success: (response) => {
        this._updateData();
      },
      error: (error) => {
        if (error.status == 500) {
          this.setState({errors: {Error: ['ERROR 500']}});
          window.scrollTo(0, 0);
        }
      }
    });
  }
}
