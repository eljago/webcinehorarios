'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import ParsedShowsRow from './ParsedShowsRow';

import PageHeader from 'react-bootstrap/lib/PageHeader';
import Pagination from 'react-bootstrap/lib/Pagination';
import Grid from 'react-bootstrap/lib/Grid';

export default class ParsedShowsMain extends React.Component {
  static propTypes = {
    currentPage: PropTypes.number,
    pagesCount: PropTypes.number,
    itemsPerPage: PropTypes.number,
    parsedShows: PropTypes.array,
    getShowsOptions: PropTypes.func,
    updateRow: PropTypes.func,
    deleteRow: PropTypes.func,
    onChangePage: PropTypes.func,
  };

  render() {
    const items = Math.ceil(this.props.pagesCount / this.props.itemsPerPage)
    return (
      <div>
        <PageHeader>Parsed Shows</PageHeader>
        <Pagination prev next first last ellipsis maxButtons={6}
          items={items}
          activePage={this.props.currentPage}
          onSelect={this.props.onChangePage}
        />
        <Grid>
          {this._getParsedShowsRows()}
        </Grid>
      </div>
    );
  }

  _getParsedShowsRows() {
    return this.props.parsedShows.map((parsedShow) => {
      return(
        <ParsedShowsRow
          key={parsedShow.id}
          parsedShow={parsedShow}
          getShowsOptions={this.props.getShowsOptions}
          updateRow={this.props.updateRow}
          deleteRow={this.props.deleteRow}
        />
      );
    });
  }
}
