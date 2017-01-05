'use strict';

import React, {PropTypes} from 'react'
import _ from 'lodash'
import ParsedShowsTabs from '../components/ParsedShowsTabs'

import {ParsedShowsQueries} from '../../../lib/api/queries'

const SHOWS_PER_PAGE = 15;

export default class ParsedShows extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      parsedShows: [],
      orphanParsedShows: [],
      relevantParsedShows: [],
      currentPage: 1,
      itemsPerPage: 15,
      pagesCount: null,
      errors: {}
    };
    _.bindAll(this, ['_updateRow', '_deleteRow', '_onChangePage']);
  }

  componentDidMount() {
    this._updateParsedShows();
    this._updateOrphanParsedShows();
    this._updateRelevantParsedShows();
  }

  render() {
    return (
      <ParsedShowsTabs
        currentPage={this.state.currentPage}
        pagesCount={this.state.pagesCount}
        itemsPerPage={this.state.itemsPerPage}
        parsedShows={this.state.parsedShows}
        orphanParsedShows={this.state.orphanParsedShows}
        relevantParsedShows={this.state.relevantParsedShows}
        updateRow={this._updateRow}
        deleteRow={this._deleteRow}
        onChangePage={this._onChangePage}
        errors={this.state.errors}
      />
    );
  }

  _updateParsedShows(page = this.state.currentPage) {
    ParsedShowsQueries.getParsedShows({
      page: page,
      perPage: SHOWS_PER_PAGE,
      success: (response) => {
        this.setState({
          currentPage: page,
          parsedShows: response.parsed_shows,
          pagesCount: response.count,
        })
      },
      error: (errors) => {

      }
    });
  }

  _onChangePage(newPage) {
    this._updateParsedShows(newPage);
  }

  _updateOrphanParsedShows() {
    ParsedShowsQueries.getOrphanParsedShows({
      success: (response) => {
        this.setState({
          orphanParsedShows: response.parsed_shows
        });
      }
    });
  }

  _updateRelevantParsedShows() {
    ParsedShowsQueries.getRelevantParsedShows({
      success: (response) => {
        this.setState({
          relevantParsedShows: response.parsed_shows
        });
      }
    });
  }

  _updateRow(parsed_show, callback) {
    ParsedShowsQueries.submitEditParsedShow({
      parsedShowId: parsed_show.id,
      parsedShow: parsed_show,
      success: (response) => {
        // window.location.assign('/admin/shows');
        this._updateParsedShows();
        this._updateOrphanParsedShows();
        this._updateRelevantParsedShows();
        callback();
      },
      error: (error) => {
        callback();
      }
    });
  }

  _deleteRow(parsed_show_id, callback) {
    ParsedShowsQueries.submitDeleteParsedShow({
      parsedShowId: parsed_show_id,
      success: (response) => {
        // window.location.assign('/admin/shows');
        this._updateOrphanParsedShows();
        this._updateParsedShows();
        callback();
      },
      error: (error) => {
        callback();
      }
    });
  }
}
