'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import ShowsMain from '../components/ShowsMain'
import ShowForm from '../components/ShowForm'

export default class Shows extends React.Component {

  constructor(props) {
    super(props);


    this.state = {
      itemsPerPage: 15,
      shows: [],
      pagesCount: null,
      loadingContent: false,
      contentType: 'all'
    };
    _.bindAll(this, [
      '_updateData',
    ]);
  }

  componentDidMount() {
    let contentType = 'all'
    const stripped_url = document.location.toString().split("#");
    if (stripped_url.length > 1)
      contentType = stripped_url[1];
    this.setState({contentType});
    this._updateData(contentType);
  }

  render() {
    return (
      <ShowsMain
        page={this.state.page}
        itemsPerPage={this.state.itemsPerPage}
        shows={this.state.shows}
        pagesCount={this.state.pagesCount}
        updateData={this._updateData}
        loadingContent={this.state.loadingContent}
      />
    );
  }

  _updateData(contentType, page = 1, searchValue = '') {
    this.setState({
      loadingContent: true,
      contentType: contentType
    });
    const queryString = `/api/shows.json?contentType=${contentType}&page=${page}&perPage=${this.state.itemsPerPage}&query=${searchValue}`;
    console.log(queryString);

    $.getJSON(queryString, (response) => {
      this.setState({
        shows: response.shows,
        pagesCount: response.count,
        loadingContent: false
      });
    });
  }
}
