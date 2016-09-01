'use strict';

import React, { PropTypes } from 'react';

import Button from 'react-bootstrap/lib/Button';
import Image from 'react-bootstrap/lib/Image';
import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';


export default class ShowsList extends React.Component {
  static propTypes = {
    shows: PropTypes.object.isRequired,
    loadingContent: PropTypes.boolean,
  };

  render() {
    return (
      <Grid>
        {this._getContent()}
      </Grid>
    )
  }

  _getContent() {
    if (this.props.loadingContent) {
      return <h1>Loading ...</h1>;
    }
    else {
      return this.props.shows.map((show, i) => {
        return(
          <Row key={show.id}>
            <Col xs={1} sm={1}>{show.id}</Col>
            <Col xs={3} sm={2}><Image src={_.get(show, 'image.smallest.url')} /></Col>
            <Col xs={6} sm={7} fluid={true}>{show.name}</Col>
            <Col xs={12} sm={2}>
              <Button
                style={{marginTop: 10, marginBottom: 10}}
                href={`/admin/shows/${show.id}/edit`}
                block>Editar</Button>
            </Col>
          </Row>
        );
      });
    }
  }
}
