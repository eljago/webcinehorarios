'use strict';

import React, { PropTypes } from 'react'
import ReactDOM from 'react-dom'
import Immutable from 'immutable'
import _ from 'lodash'
import ShowsMain from '../components/ShowsMain'
import ShowForm from '../components/ShowForm'

export default class Shows extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      page: 1,
      shows: Immutable.List(),
      hrefs: Immutable.List(),
      showsCount: null,

    };
    _.bindAll(this, ['_updateShowsTable', '_handleDelete', '_onChangePage']);
  }

  componentDidMount() {
    this._updateShowsTable();
  }

  render() {
    return (
      <ShowsMain
        page={this.state.page}
        shows={this.state.shows}
        hrefs={this.state.hrefs}
        showsCount={this.state.showsCount}
        handleDelete={this._handleDelete}
        onChangePage={this._onChangePage}
      />
    );
  }

  _updateShowsTable(newPage = this.state.page) {
    $.getJSON(`/api/shows.json?page=${newPage}`, (response) => {
      const showsHrefs = response.shows.map((show) => {
        return({
          edit: `/admin/shows/${show.slug}/edit`,
        });
      });
      this.setState({
        page: newPage,
        shows: Immutable.fromJS(response.shows),
        hrefs: Immutable.fromJS(showsHrefs),
        showsCount: response.count
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
}
