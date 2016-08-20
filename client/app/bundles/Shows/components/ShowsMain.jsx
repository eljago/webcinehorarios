'use strict';

import React, { PropTypes } from 'react';

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

// Simple example of a React "smart" component
export default class ShowsMain extends React.Component {
  static propTypes = {
    page: PropTypes.number.isRequired,
    itemsPerPage: PropTypes.number.isRequired,
    shows: PropTypes.object.isRequired,
    pagesCount: PropTypes.number.isRequired,
    onChangePage: PropTypes.func,
    onSearchShow: PropTypes.func,
    onDeleteShow: PropTypes.func,
  };

  constructor(props) {
    super(props);
    this.state = {
      searchValue: '',
    };
    _.bindAll(this, [
      '_onSearch',
      '_handleSearchInputChange',
      '_onResetSearchText',
    ]);
  }

  render() {
    const items = Math.ceil(this.props.pagesCount / this.props.itemsPerPage)
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
                if (confirm(`¿Eliminar Show ${show.name}?`)) {
                  this.props.onDeleteShow(show.id);
                }
              }}
              block>Eliminar</Button>
          </Col>
        </Row>
      );
    });

    return (
      <div className="container">
        <PageHeader>Shows <small>Main</small></PageHeader>
        <form>
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
            <Col xs={12} md={4}>
              <FormGroup>
                <InputGroup>
                  <FormControl
                    type="text"
                    ref='searchInput'
                    value={this.state.searchValue}
                    placeholder="Buscar Show"
                    onChange={this._handleSearchInputChange}
                  />
                  <InputGroup.Button>
                    <Button
                      bsStyle="danger"
                      onClick={this._onResetSearchText}
                    >
                      Reset
                    </Button>
                  </InputGroup.Button>
                </InputGroup>
              </FormGroup>
            </Col>
            <Col xs={12} md={2}>
              <Button
                type="submit"
                onClick={this._onSearch}
                block
              >
                Buscar
              </Button>
            </Col>
          </Row>
        </form>
        <Pagination prev next first last ellipsis maxButtons={6}
          items={items}
          activePage={this.props.page}
          onSelect={this.props.onChangePage}
        />
        <Grid>
          {tableRows}
        </Grid>
      </div>
    )
  }

  _handleSearchInputChange(e) {
    this.setState({searchValue: e.target.value});
  }

  _onSearch(e) {
    this.props.onSearchShow(this.state.searchValue);
    e.preventDefault();
  }

  _onResetSearchText() {
    this.setState({searchValue: ''});
    this.props.onSearchShow('');
  }
}
