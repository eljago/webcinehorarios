'use strict';

import React, {PropTypes} from 'react'
import _ from 'lodash'
import ParsedShowsTabs from '../components/ParsedShowsTabs'

import {ParsedShowsQueries, SelectQueries} from '../../../lib/api/queries'

const SHOWS_PER_PAGE = 15;

export default class ParsedShows extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      parsedShows: [],
      orphanParsedShows: [],
      currentPage: 1,
      itemsPerPage: 15,
      pagesCount: null,
      errors: {}
    };
    _.bindAll(this, ['_updateRow', '_deleteRow', '_onChangePage']);
  }

  componentDidMount() {
    this._updateOrphanParsedShows();
    this._updateParsedShows();
  }

  render() {
    return (
      <ParsedShowsTabs
        currentPage={this.state.currentPage}
        pagesCount={this.state.pagesCount}
        itemsPerPage={this.state.itemsPerPage}
        parsedShows={this.state.parsedShows}
        orphanParsedShows={this.state.orphanParsedShows}
        getShowsOptions={this._getShowsOptions}
        updateRow={this._updateRow}
        deleteRow={this._deleteRow}
        onChangePage={this._onChangePage}
        errors={this.state.errors}
      />
    );
  }

  _getShowsOptions(input, callback) {
    if (_.trim(input).length > 2) {
      SelectQueries.getShows(input, (response) => {
        callback(null, {
          options: response.shows,
        });
      });
    }
    else {
      callback(null, {options: []});
    }
  }

  _updateParsedShows(page = this.state.currentPage) {
    ParsedShowsQueries.getParsedShows({
      page: page,
      perPage: SHOWS_PER_PAGE
    }, (response) => {
      this.setState({
        currentPage: page,
        parsedShows: response.parsed_shows,
        pagesCount: response.count,
      });
    });
  }

  _onChangePage(newPage) {
    this._updateParsedShows(newPage);
  }

  _updateOrphanParsedShows() {
    ParsedShowsQueries.getOrphanParsedShows((response) => {
      this.setState({
        orphanParsedShows: response.parsed_shows
      });
    });
  }

  _updateRow(parsed_show, callback) {
    ParsedShowsQueries.submitEditParsedShow({
      parsedShowId: parsed_show.id,
      parsedShow: parsed_show
    }, (response) => {
      // window.location.assign('/admin/shows');
      this._updateOrphanParsedShows();
      this._updateParsedShows();
      callback();
    }, (error) => {
      callback();
      // Rails validations failed
      if (error.status == 422) {
        this.setState({
          errors: !_.isEmpty(error.responseJSON.errors) ? error.responseJSON.errors : {},
          submitting: false
        });
        window.scrollTo(0, 0);
      }
      else if (error.status == 500) {
        this.setState({
          errors: {Error: ['ERROR 500']},
          submitting: false
        });
        window.scrollTo(0, 0);
      }
    });
  }

  _deleteRow(parsed_show_id, callback) {
    ParsedShowsQueries.submitDeleteParsedShow({
      parsedShowId: parsed_show_id
    }, (response) => {
      // window.location.assign('/admin/shows');
      this._updateOrphanParsedShows();
      this._updateParsedShows();
      callback();
    }, (error) => {
      let errors = {};
      if (error.status == 422) { // Rails validations failed
        errors = !_.isEmpty(error.responseJSON.errors) ? error.responseJSON.errors : {},
        window.scrollTo(0, 0);
      }
      else if (error.status == 500) {
        errors = {Error: ['ERROR 500']}
        window.scrollTo(0, 0);
      }
      this.setState({
        errors: errors,
        submitting: false
      });
      callback();
    });
  }
}
