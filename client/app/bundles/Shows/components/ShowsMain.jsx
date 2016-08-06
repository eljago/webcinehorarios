'use strict';

import React, { PropTypes } from 'react';

import PageHeader from 'react-bootstrap/lib/PageHeader';
import Button from 'react-bootstrap/lib/Button';
import Image from 'react-bootstrap/lib/Image';
import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Pagination from 'react-bootstrap/lib/Pagination';

// Simple example of a React "smart" component
export default class ShowsMain extends React.Component {
  static propTypes = {
    page: PropTypes.number.isRequired,
    shows: PropTypes.object.isRequired,
    hrefs: PropTypes.array.isRequired,
    showsCount: PropTypes.number.isRequired,
    handleEdit: PropTypes.func.isRequired,
    onChangePage: PropTypes.func
  };

  constructor(props) {
    super(props);
    this.itemsPerPage = 10;
    this.items = Math.ceil(props.showsCount / this.itemsPerPage);
    this.maxButtons = this.items < 5 ? this.items : 5;
  }

  componentWillReceiveProps(nextProps) {
    this.items = Math.ceil(nextProps.showsCount / this.itemsPerPage);
    this.maxButtons = this.items < 5 ? this.items : 5;
  }

  render() {
    const {shows, hrefs} = this.props;
    const tableRows = shows.map((show, i) => {
      const href = hrefs.get(i);
      return(
        <Row>
          <Col xs={1} md={1} lg={1}>{show.get('id')}</Col>
          <Col xs={3} md={2} lg={2}><Image src={show.getIn(['image', 'smallest', 'url'])} /></Col>
          <Col xs={6} md={7} lg={7} fluid={true}>{show.get('name')}</Col>
          <Col xs={2} md={2} lg={2}>
            <Button href={href.get('edit')}>Editar</Button>
          </Col>
        </Row>
      );
    });

    return (
      <div className="container">
        <PageHeader>Shows <small>Main</small></PageHeader>
        <Pagination
          prev
          next
          first
          last
          ellipsis
          boundaryLinks
          items={this.items}
          maxButtons={this.maxButtons}
          activePage={this.props.page}
          onSelect={this.props.onChangePage}
        />
        <Grid>
          {tableRows}
        </Grid>
      </div>
    )
  }
}
