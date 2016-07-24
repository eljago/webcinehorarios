'use strict';

import React, { PropTypes } from 'react';

import PageHeader from 'react-bootstrap/lib/PageHeader';
import Button from 'react-bootstrap/lib/Button';
import Image from 'react-bootstrap/lib/Image';
import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

// Simple example of a React "smart" component
export default class ShowsMain extends React.Component {
  static propTypes = {
    shows: PropTypes.object.isRequired,
    hrefs: PropTypes.array.isRequired,
    handleEdit: PropTypes.func.isRequired,
  };

  render() {
    const {shows, hrefs} = this.props;
    const tableRows = shows.map((show, i) => {
      const href = hrefs.get(i);
      return(
        <Row>
          <Col xs={1} md={1} lg={1}>{show.get('id')}</Col>
          <Col xs={3} md={2} lg={2}><Image src={`http://cinehorarios.cl${show.getIn(['image', 'smallest', 'url'])}`} /></Col>
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
        <Grid>
          {tableRows}
        </Grid>
      </div>
    )
  }
}
