'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import ShowsMain from '../components/ShowsMain'
import ShowForm from '../components/ShowForm'

import {ShowsQueries} from '../../../lib/api/queries'

export default class Shows extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      itemsPerPage: 15,
      pagesCount: null,
      shows: [],
      loadingContent: false,
      billboard: [],
      loadingBillboard: false,
      comingSoon: [],
      loadingComingSoon: false,
    };
    _.bindAll(this, [
      '_updateData',
    ]);
  }

  componentDidMount() {
    this._updateData();
    this._updateBillboard();
    this._updateComingSoon();
  }

  render() {
    return (
      <ShowsMain
        page={this.state.page}
        itemsPerPage={this.state.itemsPerPage}
        pagesCount={this.state.pagesCount}
        updateData={this._updateData}
        shows={this.state.shows}
        loadingContent={this.state.loadingContent}
        billboard={this.state.billboard}
        loadingBillboard={this.state.loadingBillboard}
        comingSoon={this.state.comingSoon}
        loadingComingSoon={this.state.loadingComingSoon}
      />
    );
  }

  _updateData(page = 1, searchValue = '') {
    this.setState({
      loadingContent: true
    });
    ShowsQueries.getShows({
      page: page,
      perPage: this.state.itemsPerPage,
      searchValue: searchValue,
      success: (response) => {
        this.setState({
          shows: response.shows,
          pagesCount: response.count,
          loadingContent: false
        });
      },
      error: (errors) => {
        this.setState({
          loadingContent: false
        });
      }
    });
  }

  _updateBillboard() {
    this.setState({
      loadingBillboard: true
    });
    ShowsQueries.getBillboard({
      success: (response) => {
        this.setState({
          billboard: response.shows,
          loadingBillboard: false
        });
      },
      error: (errors) => {
        this.setState({
          loadingBillboard: false
        });
      }
    });
  }

  _updateComingSoon() {
    this.setState({
      loadingComingSoon: true
    });
    ShowsQueries.getComingSoon({
      success: (response) => {
        this.setState({
          comingSoon: response.shows,
          loadingComingSoon: false
        });
      },
      error: (errors) => {
        this.setState({
          loadingComingSoon: false
        });
      }
    });
  }
}
