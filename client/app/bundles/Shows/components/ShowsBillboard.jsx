'use strict';

import React, { PropTypes } from 'react';

import ShowsList from './ShowsList'

import SearchField from '../../../lib/forms/FormFields/SearchField'

import PageHeader from 'react-bootstrap/lib/PageHeader';
import Button from 'react-bootstrap/lib/Button';
import Image from 'react-bootstrap/lib/Image';
import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Pagination from 'react-bootstrap/lib/Pagination';
import FormGroup from 'react-bootstrap/lib/FormGroup';
import FormControl from 'react-bootstrap/lib/FormControl';
import InputGroup from 'react-bootstrap/lib/InputGroup';


export default class ShowsMain extends React.Component {
  static propTypes = {
    itemsPerPage: PropTypes.number.isRequired,
    shows: PropTypes.object.isRequired,
    pagesCount: PropTypes.number.isRequired,
    updateData: PropTypes.func,
    loadingContent: PropTypes.boolean,
  };

  constructor(props) {
    super(props);
    this.state = {
      contentType: 'all',
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
                this._updateData(this.state.contentType, this.state.page, searchValue);
              }}
              onChange={(newSearchValue) => {
                this.setState({searchValue: newSearchValue});
              }}
            />
          </Col>
        </Row>
        <Row><Col xs={12} smHidden mdHidden lgHidden><br/></Col></Row>  
        <Row>
          <Col xs={4}>
            <Button
              block
              bsStyle={this.state.contentType === 'all' ? "primary" : 'default'}
              onClick={() => {
                this._updateData('all')
                this.setState({searchDisabled: false})
              }}
            >Todos</Button>
          </Col>
          <Col xs={4}>
            <Button
              block
              bsStyle={this.state.contentType === 'billboard' ? "primary" : 'default'}
              onClick={() => {
                this._updateData('billboard')
                this.setState({searchDisabled: true})
              }}
            >Cartelera</Button>
          </Col>
          <Col xs={4}>
            <Button
              block
              bsStyle={this.state.contentType === 'comingsoon' ? "primary" : 'default'}
              onClick={() => {
                this._updateData('comingsoon')
                this.setState({searchDisabled: true})
              }}
            >Próximamente</Button>
          </Col>
        </Row>
        {this._getPagination()}
        <ShowsList
          shows={this.props.shows}
          loadingContent={this.props.loadingContent}
        />
        {this._getPagination()}
      </div>
    )
  }

  _updateData(newContentType, newPage = this.state.page, newSearchValue = this.state.searchValue) {
    this.props.updateData(newContentType, newPage, newSearchValue);
    this.setState({
      contentType: newContentType,
      page: newPage,
      searchValue: newSearchValue
    });
  }

  _getPagination() {
    if (this.state.contentType === 'all') {
      return <Pagination prev next first last ellipsis maxButtons={5}
        items={Math.ceil(this.props.pagesCount / this.props.itemsPerPage)}
        activePage={this.state.page}
        onSelect={(newPage) => {
          this._updateData('all', newPage)
        }}
      />
    }
    return <br/>;
  }
}