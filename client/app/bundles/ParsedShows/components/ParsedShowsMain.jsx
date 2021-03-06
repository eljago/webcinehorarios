'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import ParsedShowsRow from './ParsedShowsRow';
import {SelectQueries} from '../../../lib/api/queries'

import PageHeader from 'react-bootstrap/lib/PageHeader';
import Pagination from 'react-bootstrap/lib/Pagination';

export default class ParsedShowsMain extends React.Component {
  static propTypes = {
    currentPage: PropTypes.number,
    pagesCount: PropTypes.number,
    itemsPerPage: PropTypes.number,
    parsedShows: PropTypes.array,
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
        {this._getParsedShowsRows()}
      </div>
    );
  }

  _getParsedShowsRows() {
    return this.props.parsedShows.map((parsedShow) => {
      return(
        <ParsedShowsRow
          key={parsedShow.id}
          parsedShow={parsedShow}
          getShowsOptions={SelectQueries.getShowsOptions}
          updateRow={this.props.updateRow}
          deleteRow={this.props.deleteRow}
        />
      );
    });
  }
}
