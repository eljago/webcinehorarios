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
    };
    _.bindAll(this, 
      [
        '_updateShowsTable',
        '_handleDelete',
      ]
    );
  }

  componentDidMount() {
    this._updateShowsTable();
  }

  render() {
    return (
      <ShowsMain
        shows={this.state.shows}
        hrefs={this.state.hrefs}
        handleDelete={this._handleDelete}
      />
    );
  }

  _updateShowsTable() {
    $.getJSON(`/api/shows.json?page=${this.state.page}`, (response) => {
      const showsHrefs = response.map((show) => {
        return({
          edit: `/admin/shows/${show.slug}/edit`,
        });
      });
      this.setState({
        shows: Immutable.fromJS(response),
        hrefs: Immutable.fromJS(showsHrefs),
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
}
