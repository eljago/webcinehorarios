'use strict';

import React, { PropTypes } from 'react';

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
    onDeleteShow: PropTypes.func,
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
      <div className="container">
        <PageHeader>Shows <small>Main</small></PageHeader>
        <Row>
          <Col xs={12} md={2}>
            <Button
              style={{marginBottom: 10}}
              bsStyle="primary"
              href='/admin/shows/new'
              block
            >
              Nuevo
            </Button>
          </Col>
          <Col xs={12} md={8}>
            <SearchField
              ref='searchField'
              placeholder='Buscar Show'
              disabled={this.state.searchDisabled}
              onSearch={(searchValue) => {
                this.props.updateData(this.state.contentType, this.props.page, searchValue)
              }}
              onChange={(newSearchValue) => {
                this.setState({searchValue: newSearchValue});
              }}
            />
          </Col>
        </Row>
        <Row>
          <Col xs={4}>
            <Button
              block
              bsStyle={this.state.contentType === 'all' ? "primary" : 'default'}
              onClick={() => {
                this._updateData('all', 1)
                this.setState({searchDisabled: false})
              }}
            >Todos</Button>
          </Col>
          <Col xs={4}>
            <Button
              block
              bsStyle={this.state.contentType === 'billboard' ? "primary" : 'default'}
              onClick={() => {
                this._updateData('billboard', 1)
                this.setState({searchDisabled: true})
              }}
            >Cartelera</Button>
          </Col>
          <Col xs={4}>
            <Button
              block
              bsStyle={this.state.contentType === 'comingsoon' ? "primary" : 'default'}
              onClick={() => {
                this._updateData('comingsoon', 1)
                this.setState({searchDisabled: true})
              }}
            >Próximamente</Button>
          </Col>
        </Row>
        {this._getPagination()}
        {this._getContent()}
      </div>
    )
  }

  _updateData(newContentType, newPage, newSearchValue = this.state.searchValue) {
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
          this._updateData('all', newPage, this.state.searchValue)
        }}
      />
    }
    return <br/>;
  }

  _getContent() {
    if (this.props.loadingContent) {
      return <h1>Loading ...</h1>;
    }
    else {
      const tableRows = this.props.shows.map((show, i) => {
        return(
          <Row key={show.id}>
            <Col xs={1} md={1} lg={1}>{show.id}</Col>
            <Col xs={3} md={2} lg={2}><Image src={`http://cinehorarios.cl${_.get(show, 'image.smallest.url')}`} /></Col>
            <Col xs={6} md={5} lg={5} fluid={true}>{show.name}</Col>
            <Col xs={12} md={2} lg={2}>
              <Button
                style={{marginTop: 10, marginBottom: 10}}
                href={`/admin/shows/${show.id}/edit`}
                block>Editar</Button>
            </Col>
            <Col xs={12} md={2} lg={2}>
              <Button
                style={{marginTop: 10, marginBottom: 10}}
                bsStyle="danger"
                onClick={() => {
                  if (confirm(`¿Eliminar Show: ${show.name}?`)) {
                    this.props.onDeleteShow(show.id);
                  }
                }}
                block>Eliminar</Button>
            </Col>
          </Row>
        );
      });
      return(
        <Row>
          <Col xs={12}>
            <Grid>
              {tableRows}
            </Grid>
          </Col>
        </Row>
      ); 
    }
  }
}
