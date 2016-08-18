'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import ParsedShowsMain from './ParsedShowsMain';
import ParsedShowsOrphan from './ParsedShowsOrphan';

import Nav from 'react-bootstrap/lib/Nav';
import NavItem from 'react-bootstrap/lib/NavItem';

export default class ParsedShowsTabs extends React.Component {
  static propTypes = {
    currentPage: PropTypes.number,
    pagesCount: PropTypes.number,
    itemsPerPage: PropTypes.number,
    parsedShows: PropTypes.array,
    orphanParsedShows: PropTypes.array,
    getShowsOptions: PropTypes.func,
    updateRow: PropTypes.func,
    deleteRow: PropTypes.func,
    onChangePage: PropTypes.func,
  };

  constructor(props) {
    super(props);
    this.state = {
      selectedNavItem: 2
    };
    _.bindAll(this, '_handleSelect');
  }

  componendDidMount() {
    this.setState({selectedNavItem: 1})
  }

  render() {
    return (
      <div className="container">
        <Nav bsStyle="pills" activeKey={this.state.selectedNavItem} onSelect={this._handleSelect}>
          <NavItem eventKey="1">Parsed Shows</NavItem>
          <NavItem eventKey="2">Orphan Parsed Shows</NavItem>
        </Nav>
        {this._getContent()}
      </div>
    );
  }

  _handleSelect(selectedNavItem) {
    this.setState({selectedNavItem});
  }

  _getContent() {
    if (this.state.selectedNavItem == 1) {
      return (
        <ParsedShowsMain
          currentPage={this.props.currentPage}
          pagesCount={this.props.pagesCount}
          itemsPerPage={this.props.itemsPerPage}
          parsedShows={this.props.parsedShows}
          getShowsOptions={this.props.getShowsOptions}
          updateRow={this.props.updateRow}
          deleteRow={this.props.deleteRow}
          onChangePage={this.props.onChangePage}
        />
      );
    }
    else if (this.state.selectedNavItem == 2) {
      return (
        <ParsedShowsOrphan
          orphanParsedShows={this.props.orphanParsedShows}
          getShowsOptions={this.props.getShowsOptions}
          updateRow={this.props.updateRow}
          deleteRow={this.props.deleteRow}
        />
      );
    }
    return null;
  }
}