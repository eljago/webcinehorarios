'use strict';

import React, { PropTypes } from 'react';

import ShowsList from './ShowsList'

import SearchField from '../../../lib/forms/FormFields/SearchField'

import Button from 'react-bootstrap/lib/Button';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Pagination from 'react-bootstrap/lib/Pagination';

export default class ShowsMain extends React.Component {
  static propTypes = {
    itemsPerPage: PropTypes.number.isRequired,
    pagesCount: PropTypes.number.isRequired,
    updateData: PropTypes.func,
    shows: PropTypes.object.isRequired,
    loadingContent: PropTypes.boolean,
    billboard: PropTypes.array,
    loadingBillboard: PropTypes.boolean,
    comingSoon: PropTypes.array,
    loadingComingSoon: PropTypes.boolean,
  };

  constructor(props) {
    super(props);
    this.state = {
      page: 1,
      searchValue: '',
      searchDisabled: false
    }
  }

  render() {
    return (
      <div>
        <Row>
          <Col xs={12} sm={2}>
            <Button
              style={{marginBottom: 10}}
              bsStyle="primary"
              href='/admin/shows/new'
              block
            >
              Nuevo
            </Button>
          </Col>
          <Col xs={12} sm={8}>
            <SearchField
              ref='searchField'
              placeholder='Buscar Show'
              disabled={this.state.searchDisabled}
              onSearch={(searchValue) => {
                this._updateData(this.state.page, searchValue);
              }}
              onChange={(newSearchValue) => {
                this.setState({searchValue: newSearchValue});
              }}
            />
          </Col>
        </Row>
        <Row>
          <Col sm={4}>
            {this._getPagination()}
            <ShowsList
              shows={this.props.shows}
              loadingContent={this.props.loadingContent}
            />
            {this._getPagination()}
          </Col>
          <Col sm={4}>
            <h3 style={{marginBottom: 32}}>Cartelera</h3>
            <ShowsList
              shows={this.props.billboard}
              loadingContent={this.props.loadingBillboard}
            />
          </Col>
          <Col sm={4}>
            <h3 style={{marginBottom: 32}}>Próximamente</h3>
            <ShowsList
              shows={this.props.comingSoon}
              loadingContent={this.props.loadingComingSoon}
            />
          </Col>
        </Row>
      </div>
    )
  }

  _updateData(newPage = this.state.page, newSearchValue = this.state.searchValue) {
    this.props.updateData(newPage, newSearchValue);
    this.setState({
      page: newPage,
      searchValue: newSearchValue
    });
  }

  _getPagination() {
    return (
      <Pagination prev next first last ellipsis maxButtons={5}
        items={Math.ceil(this.props.pagesCount / this.props.itemsPerPage)}
        activePage={this.state.page}
        onSelect={(newPage) => {
          this._updateData(newPage)
        }}
      />
    );
  }
}
