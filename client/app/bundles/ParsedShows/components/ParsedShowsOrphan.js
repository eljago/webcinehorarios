'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import ParsedShowsRow from './ParsedShowsRow';
import {SelectQueries} from '../../../lib/api/queries'

import PageHeader from 'react-bootstrap/lib/PageHeader';

export default class ParsedShowsOrphan extends React.Component {
  static propTypes = {
    orphanParsedShows: PropTypes.array,
    updateRow: PropTypes.func,
    deleteRow: PropTypes.func,
  };

  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div>
        <PageHeader>Orphan Parsed Shows</PageHeader>
        <form>
          {this._getOrphanParsedShowsRows()}
        </form>
      </div>
    );
  }

  _getOrphanParsedShowsRows() {
    return this.props.orphanParsedShows.map((parsedShow) => {
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
